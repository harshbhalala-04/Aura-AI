import 'package:flutter/material.dart';

class AppConstant {
  static const String APP_NAME = 'Aura AI';
  static const Color PRIMARY_COLOR = Color(0xFF7F5AF0);
  static const Color SECONDARY_COLOR = Color(0xFF242633);
  static const Color ACCENT_COLOR = Color(0xFF26D9B1);
  static const Color BACKGROUND_COLOR = Color(0xFF1A1C27);
  static const Color SURFACE_COLOR = Color(0xFF242633);
  static const Color ERROR_COLOR = Color(0xFFB00020);
  static const Color TEXT_PRIMARY = Color(0xFFFFFFFF);
  static const Color TEXT_SECONDARY = Color(0xFF94A1B2);
  
  static const Gradient PRIMARY_GRADIENT = LinearGradient(
    colors: [Color(0xFFA890FF), Color(0xFF7F5AF0)],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  static const String GEMINI_API_KEY = 'GEMINI_API_KEY';
  static const String OPEN_AI_API_KEY = 'OPEN_AI_API_KEY';
  static const String CLAUDE_API_KEY = 'CLAUDE_API_KEY';
  static const String GEMINI_API_URL = 'https://generativelanguage.googleapis.com/v1beta/models/';
  static const String TEXT_MODEL = 'gemini-2.5-flash';
  static const double TEMPERATURE = 0.8;
  static const int MAX_TOKENS = 4096;
  static const double TOP_P = 0.95;
  static const int TOP_K = 40;

  static const double PADDING_SMALL = 8.0;
  static const double PADDING_MEDIUM = 16.0;
  static const double PADDING_LARGE = 24.0;
  static const double PADDING_XL = 32.0;

  static const double BORDER_RADIUS_MEDIUM = 8.0;
  static const double BORDER_RADIUS_LARGE = 16.0;

  static const double FONT_BODY = 14.0;
  static const double FONT_SUBTITLE = 16.0;
  static const double FONT_TITLE = 20.0;
  static const double FONT_HEADLINE = 24.0;
}