import 'dart:async';

import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../services/weather_service.dart';
import '../../../theme/app_colors.dart';
import '../notification_service.dart';

class FavoritesScreen extends StatefulWidget {
  const FavoritesScreen({super.key});

  @override
  State<FavoritesScreen> createState() => _FavoritesScreenState();
}

class _FavoritesScreenState extends State<FavoritesScreen> {
  final TextEditingController _controller = TextEditingController();
  final WeatherService _weatherService = WeatherService();
  final NotificationService _notificationService = NotificationService();
  List<String> _favorites = [];
  Timer? _timer;
  bool _notifying = false;

  @override
  void initState() {
    super.initState();
    _loadFavorites();
    _notificationService.init();
  }

  @override
  void dispose() {
    _timer?.cancel();
    _controller.dispose();
    super.dispose();
  }

  Future<void> _loadFavorites() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      _favorites = prefs.getStringList('favorites') ?? [];
    });
  }

  Future<void> _saveFavorites() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setStringList('favorites', _favorites);
  }

  Future<void> _addFavorite() async {
    final city = _controller.text.trim();
    if (city.isEmpty) return;
    if (!_favorites.contains(city)) {
      setState(() => _favorites.add(city));
      await _saveFavorites();
    }
    _controller.clear();
  }

  Future<void> _removeFavorite(String city) async {
    setState(() => _favorites.remove(city));
    await _saveFavorites();
  }

  Future<void> _notifyNow() async {
    for (var i = 0; i < _favorites.length; i++) {
      final city = _favorites[i];
      try {
        final temp = await _weatherService.fetchTemperature(city);
        await _notificationService.showNotification(
          id: i,
          title: 'Météo : $city',
          body: 'Temp : $temp°C',
        );
      } catch (e) {
        await _notificationService.showNotification(
          id: i + 1000,
          title: 'Météo : $city',
          body: 'Erreur : $e',
        );
      }
    }
  }

  void _startPeriodicNotifications() {
    _timer?.cancel();
    _notifyNow();
    _timer = Timer.periodic(const Duration(minutes: 10), (_) async {
      await _notifyNow();
    });
    setState(() => _notifying = true);
  }

  void _stopPeriodicNotifications() {
    _timer?.cancel();
    _notificationService.cancelAll();
    setState(() => _notifying = false);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        title: const Text('Favoris'),
      ),
      body: Container(
        decoration: const BoxDecoration(gradient: AppColors.skyGradient),
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
            child: Column(
              children: [
                // champ d'ajout
                _GlassCard(
                  child: Row(
                    children: [
                      Expanded(
                        child: TextField(
                          controller: _controller,
                          style: const TextStyle(color: AppColors.textPrimary),
                          decoration: const InputDecoration(
                            hintText: 'Ajouter une ville…',
                            border: InputBorder.none,
                            enabledBorder: InputBorder.none,
                            focusedBorder: InputBorder.none,
                            filled: false,
                            contentPadding: EdgeInsets.symmetric(horizontal: 16, vertical: 14),
                            prefixIcon: Icon(Icons.add_location_alt_rounded, color: AppColors.iconMuted),
                          ),
                          onSubmitted: (_) => _addFavorite(),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(right: 8),
                        child: ElevatedButton(
                          onPressed: _addFavorite,
                          style: ElevatedButton.styleFrom(
                            backgroundColor: AppColors.skyBlue,
                            foregroundColor: AppColors.bgDeep,
                            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10),
                            ),
                            minimumSize: Size.zero,
                            tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                          ),
                          child: const Text('Ajouter'),
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 12),
                // boutons notification
                Row(
                  children: [
                    Expanded(
                      child: _NotifButton(
                        label: 'Démarrer',
                        icon: Icons.notifications_active_rounded,
                        active: true,
                        enabled: _favorites.isNotEmpty && !_notifying,
                        onPressed: _startPeriodicNotifications,
                      ),
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                      child: _NotifButton(
                        label: 'Arrêter',
                        icon: Icons.notifications_off_rounded,
                        active: false,
                        enabled: _notifying,
                        onPressed: _stopPeriodicNotifications,
                      ),
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                      child: _NotifButton(
                        label: 'Notifier',
                        icon: Icons.send_rounded,
                        active: true,
                        enabled: _favorites.isNotEmpty,
                        onPressed: _notifyNow,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                // liste favoris
                Expanded(
                  child: _favorites.isEmpty
                      ? Center(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: const [
                              Icon(
                                Icons.favorite_border_rounded,
                                size: 48,
                                color: AppColors.textMuted,
                              ),
                              SizedBox(height: 12),
                              Text(
                                'Aucun favori pour l\'instant',
                                style: TextStyle(color: AppColors.textMuted),
                              ),
                            ],
                          ),
                        )
                      : ListView.separated(
                          itemCount: _favorites.length,
                          separatorBuilder: (context, idx) => const SizedBox(height: 8),
                          itemBuilder: (context, index) {
                            final city = _favorites[index];
                            return Container(
                              decoration: BoxDecoration(
                                color: AppColors.bgGlass,
                                borderRadius: BorderRadius.circular(14),
                                border: Border.all(color: AppColors.border),
                              ),
                              child: ListTile(
                                leading: const Icon(
                                  Icons.location_city_rounded,
                                  color: AppColors.skyBlue,
                                ),
                                title: Text(
                                  city,
                                  style: const TextStyle(
                                    color: AppColors.textPrimary,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                                trailing: IconButton(
                                  icon: const Icon(
                                    Icons.delete_outline_rounded,
                                    color: AppColors.error,
                                  ),
                                  onPressed: () => _removeFavorite(city),
                                ),
                              ),
                            );
                          },
                        ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _GlassCard extends StatelessWidget {
  const _GlassCard({required this.child});
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: AppColors.bgGlass,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.border),
      ),
      child: child,
    );
  }
}

class _NotifButton extends StatelessWidget {
  const _NotifButton({
    required this.label,
    required this.icon,
    required this.active,
    required this.enabled,
    required this.onPressed,
  });

  final String label;
  final IconData icon;
  final bool active;
  final bool enabled;
  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    return ElevatedButton.icon(
      icon: Icon(icon, size: 16),
      label: Text(label),
      onPressed: enabled ? onPressed : null,
      style: ElevatedButton.styleFrom(
        backgroundColor: active ? AppColors.skyBlue.withValues(alpha: 0.15) : AppColors.bgGlass,
        foregroundColor: enabled ? AppColors.skyBlue : AppColors.textMuted,
        elevation: 0,
        side: BorderSide(
          color: enabled ? AppColors.border : AppColors.divider,
        ),
        padding: const EdgeInsets.symmetric(vertical: 12),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        textStyle: const TextStyle(fontSize: 12, fontWeight: FontWeight.w600),
      ),
    );
  }
}
