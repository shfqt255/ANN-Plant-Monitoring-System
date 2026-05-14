import 'package:flutter/material.dart';
import 'package:plant_care/Model/plant_input_model.dart';
import 'package:plant_care/Provider/provider.dart';
import 'package:provider/provider.dart';

// ─── Color Palette ────────────────────────────────────────────────────────────
// Primary:    #1A3C34  (deep forest)
// Surface:    #F5F7F5  (off-white sage)
// Card:       #FFFFFF
// Accent:     #2D7A4F  (emerald)
// Light Acc:  #E8F5EE  (mint tint)
// Text:       #1C2B27  (dark forest)
// Muted:      #7A9690  (sage grey)
// Water:      #3B9ED0  (sky blue)
// Health OK:  #2D7A4F  (emerald)
// Alert:      #D95F3B  (terracotta)

class AppColors {
  static const background = Color(0xFFF5F7F5);
  static const surface = Color(0xFFFFFFFF);
  static const primary = Color(0xFF1A3C34);
  static const accent = Color(0xFF2D7A4F);
  static const accentLight = Color(0xFFE8F5EE);
  static const textDark = Color(0xFF1C2B27);
  static const textMuted = Color(0xFF7A9690);
  static const waterBlue = Color(0xFF3B9ED0);
  static const waterBlueLight = Color(0xFFE3F4FB);
  static const alertRed = Color(0xFFD95F3B);
  static const alertRedLight = Color(0xFFFBEDE8);
  static const divider = Color(0xFFE4EBE8);
}

class HomeScreen extends StatelessWidget {
  HomeScreen({super.key});

  final temp = TextEditingController();
  final humidity = TextEditingController();
  final moisture = TextEditingController();
  final ph = TextEditingController();
  final nutrient = TextEditingController();
  final light = TextEditingController();

  void _onPredict(BuildContext context, PlantProvider provider) {
    // Dismiss keyboard
    FocusScope.of(context).unfocus();

    final model = PlantInputModel(
      temperature: double.tryParse(temp.text) ?? 0,
      humidity: double.tryParse(humidity.text) ?? 0,
      soilMoisture: double.tryParse(moisture.text) ?? 0,
      soilPH: double.tryParse(ph.text) ?? 0,
      nutrientLevel: double.tryParse(nutrient.text) ?? 0,
      lightIntensity: double.tryParse(light.text) ?? 0,
    );

    provider.predictPlant(model);
  }

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<PlantProvider>(context);

    return Scaffold(
      backgroundColor: AppColors.background,
      body: CustomScrollView(
        slivers: [
          _AppBar(),
          SliverPadding(
            padding: const EdgeInsets.fromLTRB(20, 8, 20, 32),
            sliver: SliverList(
              delegate: SliverChildListDelegate([
                _SectionLabel(label: "Sensor Readings"),
                const SizedBox(height: 12),
                _InputGrid(
                  controllers: {
                    "Temperature": (temp, Icons.thermostat_outlined, "°C"),
                    "Humidity": (humidity, Icons.water_outlined, "%"),
                    "Soil Moisture": (moisture, Icons.grass_outlined, "%"),
                    "pH Level": (ph, Icons.science_outlined, "pH"),
                    "Nutrient Level": (nutrient, Icons.eco_outlined, "mg/L"),
                    "Light Intensity": (
                      light,
                      Icons.light_mode_outlined,
                      "lux",
                    ),
                  },
                ),
                const SizedBox(height: 28),
                _PredictButton(
                  loading: provider.loading,
                  onPressed: () => _onPredict(context, provider),
                ),
                const SizedBox(height: 28),
                if (provider.loading) ...[
                  _LoadingCard(),
                ] else if (provider.waterResult.isNotEmpty ||
                    provider.healthResult.isNotEmpty) ...[
                  _SectionLabel(label: "Diagnosis Results"),
                  const SizedBox(height: 12),
                  if (provider.waterResult.isNotEmpty)
                    _ResultCard(
                      icon: Icons.water_drop_outlined,
                      title: "Hydration",
                      result: provider.waterResult,
                      confidence: provider.waterProb,
                      isAlert: provider.waterResult == "Needs Water",
                      alertColor: AppColors.waterBlue,
                      alertLightColor: AppColors.waterBlueLight,
                    ),
                  if (provider.waterResult.isNotEmpty &&
                      provider.healthResult.isNotEmpty)
                    const SizedBox(height: 12),
                  if (provider.healthResult.isNotEmpty)
                    _ResultCard(
                      icon: Icons.favorite_outline,
                      title: "Plant Health",
                      result: provider.healthResult,
                      confidence: provider.healthProb,
                      isAlert: provider.healthResult.toLowerCase() != "healthy",
                      alertColor:
                          provider.healthResult.toLowerCase() == "healthy"
                          ? AppColors.accent
                          : AppColors.alertRed,
                      alertLightColor:
                          provider.healthResult.toLowerCase() == "healthy"
                          ? AppColors.accentLight
                          : AppColors.alertRedLight,
                    ),
                ],
              ]),
            ),
          ),
        ],
      ),
    );
  }
}

// ─── App Bar ──────────────────────────────────────────────────────────────────

class _AppBar extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return SliverAppBar(
      expandedHeight: 130,
      floating: false,
      pinned: true,
      backgroundColor: AppColors.primary,
      elevation: 0,
      flexibleSpace: FlexibleSpaceBar(
        titlePadding: const EdgeInsets.fromLTRB(20, 0, 20, 16),
        title: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(6),
              decoration: BoxDecoration(
                color: Colors.white.withOpacity(0.15),
                borderRadius: BorderRadius.circular(8),
              ),
              child: const Text("🌿", style: TextStyle(fontSize: 16)),
            ),
            const SizedBox(width: 10),
            Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  "PlantCare AI",
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 17,
                    fontWeight: FontWeight.w700,
                    letterSpacing: -0.3,
                  ),
                ),
                Text(
                  "Plant Health Monitor",
                  style: TextStyle(
                    color: Colors.white.withOpacity(0.65),
                    fontSize: 10,
                    fontWeight: FontWeight.w400,
                    letterSpacing: 0.4,
                  ),
                ),
              ],
            ),
          ],
        ),
        background: Container(
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [Color(0xFF1A3C34), Color(0xFF2D5A44)],
            ),
          ),
          child: Align(
            alignment: Alignment.topRight,
            child: Padding(
              padding: const EdgeInsets.all(20),
              child: Opacity(
                opacity: 0.07,
                child: const Text("🌱", style: TextStyle(fontSize: 110)),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

// ─── Section Label ────────────────────────────────────────────────────────────

class _SectionLabel extends StatelessWidget {
  final String label;
  const _SectionLabel({required this.label});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Container(
          width: 3,
          height: 14,
          decoration: BoxDecoration(
            color: AppColors.accent,
            borderRadius: BorderRadius.circular(2),
          ),
        ),
        const SizedBox(width: 8),
        Text(
          label.toUpperCase(),
          style: const TextStyle(
            fontSize: 11,
            fontWeight: FontWeight.w700,
            color: AppColors.textMuted,
            letterSpacing: 1.2,
          ),
        ),
      ],
    );
  }
}

// ─── Input Grid ───────────────────────────────────────────────────────────────

class _InputGrid extends StatelessWidget {
  final Map<String, (TextEditingController, IconData, String)> controllers;

  const _InputGrid({required this.controllers});

  @override
  Widget build(BuildContext context) {
    final entries = controllers.entries.toList();
    return Column(
      children: [
        for (int i = 0; i < entries.length; i += 2)
          Padding(
            padding: EdgeInsets.only(bottom: i + 2 < entries.length ? 12 : 0),
            child: Row(
              children: [
                Expanded(
                  child: _InputField(
                    label: entries[i].key,
                    controller: entries[i].value.$1,
                    icon: entries[i].value.$2,
                    unit: entries[i].value.$3,
                  ),
                ),
                if (i + 1 < entries.length) ...[
                  const SizedBox(width: 12),
                  Expanded(
                    child: _InputField(
                      label: entries[i + 1].key,
                      controller: entries[i + 1].value.$1,
                      icon: entries[i + 1].value.$2,
                      unit: entries[i + 1].value.$3,
                    ),
                  ),
                ],
              ],
            ),
          ),
      ],
    );
  }
}

// ─── Input Field ──────────────────────────────────────────────────────────────

class _InputField extends StatelessWidget {
  final String label;
  final TextEditingController controller;
  final IconData icon;
  final String unit;

  const _InputField({
    required this.label,
    required this.controller,
    required this.icon,
    required this.unit,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(14),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.04),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: TextField(
        controller: controller,
        keyboardType: const TextInputType.numberWithOptions(decimal: true),
        style: const TextStyle(
          fontSize: 15,
          fontWeight: FontWeight.w600,
          color: AppColors.textDark,
        ),
        decoration: InputDecoration(
          labelText: label,
          labelStyle: const TextStyle(
            fontSize: 12,
            color: AppColors.textMuted,
            fontWeight: FontWeight.w500,
          ),
          suffixText: unit,
          suffixStyle: const TextStyle(
            fontSize: 12,
            color: AppColors.textMuted,
          ),
          prefixIcon: Icon(icon, size: 18, color: AppColors.accent),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(14),
            borderSide: const BorderSide(color: AppColors.divider),
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(14),
            borderSide: const BorderSide(color: AppColors.divider),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(14),
            borderSide: const BorderSide(color: AppColors.accent, width: 1.5),
          ),
          filled: true,
          fillColor: AppColors.surface,
          contentPadding: const EdgeInsets.symmetric(
            horizontal: 14,
            vertical: 14,
          ),
        ),
      ),
    );
  }
}

// ─── Predict Button ───────────────────────────────────────────────────────────

class _PredictButton extends StatelessWidget {
  final bool loading;
  final VoidCallback onPressed;

  const _PredictButton({required this.loading, required this.onPressed});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      height: 54,
      child: ElevatedButton(
        onPressed: loading ? null : onPressed,
        style: ElevatedButton.styleFrom(
          backgroundColor: AppColors.accent,
          disabledBackgroundColor: AppColors.accent.withOpacity(0.5),
          foregroundColor: Colors.white,
          elevation: 0,
          shadowColor: Colors.transparent,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
        ),
        child: loading
            ? const SizedBox(
                width: 22,
                height: 22,
                child: CircularProgressIndicator(
                  color: Colors.white,
                  strokeWidth: 2.5,
                ),
              )
            : const Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.biotech_outlined, size: 20),
                  SizedBox(width: 10),
                  Text(
                    "Run Diagnosis",
                    style: TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.w700,
                      letterSpacing: 0.3,
                    ),
                  ),
                ],
              ),
      ),
    );
  }
}

// ─── Loading Card ─────────────────────────────────────────────────────────────

class _LoadingCard extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 32),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(18),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.04),
            blurRadius: 10,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Column(
        children: [
          const SizedBox(
            width: 36,
            height: 36,
            child: CircularProgressIndicator(
              color: AppColors.accent,
              strokeWidth: 2.5,
            ),
          ),
          const SizedBox(height: 16),
          const Text(
            "Analyzing plant data...",
            style: TextStyle(
              color: AppColors.textMuted,
              fontSize: 14,
              fontWeight: FontWeight.w500,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            "AI model is processing",
            style: TextStyle(
              color: AppColors.textMuted.withOpacity(0.6),
              fontSize: 12,
            ),
          ),
        ],
      ),
    );
  }
}

// ─── Result Card ──────────────────────────────────────────────────────────────

class _ResultCard extends StatelessWidget {
  final IconData icon;
  final String title;
  final String result;
  final double confidence;
  final bool isAlert;
  final Color alertColor;
  final Color alertLightColor;

  const _ResultCard({
    required this.icon,
    required this.title,
    required this.result,
    required this.confidence,
    required this.isAlert,
    required this.alertColor,
    required this.alertLightColor,
  });

  @override
  Widget build(BuildContext context) {
    final pct = (confidence * 100).toStringAsFixed(1);
    final fill = confidence.clamp(0.0, 1.0);

    return Container(
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(18),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 12,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: alertLightColor,
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Icon(icon, size: 18, color: alertColor),
              ),
              const SizedBox(width: 12),
              Text(
                title,
                style: const TextStyle(
                  fontSize: 13,
                  fontWeight: FontWeight.w600,
                  color: AppColors.textMuted,
                  letterSpacing: 0.2,
                ),
              ),
              const Spacer(),
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 10,
                  vertical: 4,
                ),
                decoration: BoxDecoration(
                  color: alertLightColor,
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Text(
                  "$pct%",
                  style: TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w700,
                    color: alertColor,
                  ),
                ),
              ),
            ],
          ),

          const SizedBox(height: 14),

          // Result text
          Text(
            result,
            style: const TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.w700,
              color: AppColors.textDark,
              letterSpacing: -0.3,
            ),
          ),

          const SizedBox(height: 12),

          // Confidence bar
          ClipRRect(
            borderRadius: BorderRadius.circular(6),
            child: LinearProgressIndicator(
              value: fill,
              minHeight: 6,
              backgroundColor: AppColors.divider,
              valueColor: AlwaysStoppedAnimation<Color>(alertColor),
            ),
          ),

          const SizedBox(height: 6),

          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                "Confidence level",
                style: TextStyle(
                  fontSize: 11,
                  color: AppColors.textMuted.withOpacity(0.7),
                ),
              ),
              Text(
                "$pct% accurate",
                style: TextStyle(
                  fontSize: 11,
                  color: alertColor,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
