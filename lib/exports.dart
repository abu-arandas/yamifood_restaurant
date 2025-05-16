/* ====== Packages ====== */
export 'package:flutter/material.dart';
export 'package:flutter/gestures.dart';
export 'package:flutter/foundation.dart';

export 'dart:convert';
export 'dart:async';

export 'firebase_options.dart';
export 'package:firebase_core/firebase_core.dart';
export 'package:firebase_auth/firebase_auth.dart';
export 'package:cloud_firestore/cloud_firestore.dart' hide kIsWasm;
export 'package:firebase_messaging/firebase_messaging.dart';
export 'package:firebase_storage/firebase_storage.dart';

/* ====== GetX ====== */
export 'package:get/get.dart';
export 'package:get_storage/get_storage.dart';

/* ====== UI Packages ====== */
export 'package:flutter_staggered_animations/flutter_staggered_animations.dart';
export 'package:shimmer/shimmer.dart';
export 'package:cached_network_image/cached_network_image.dart';
export 'package:flutter_animate/flutter_animate.dart';
// Hide the conflicting RefreshIndicator and RefreshIndicatorState
export 'package:pull_to_refresh/pull_to_refresh.dart' hide RefreshIndicator, RefreshIndicatorState;
export 'package:google_fonts/google_fonts.dart';

/* ====== App Exports ====== */
// Models
export 'app/models/models.dart';

// Controllers
export 'app/controllers/controllers.dart';

// Views
export 'app/views/views.dart';

// Utils
export 'app/utils/utils.dart';

// Bindings
export 'app/bindings/bindings.dart';

// Routes
export 'app/routes/app_pages.dart';

// Services
export 'app/services/services.dart';

// Widgets
export 'app/widgets/widgets.dart';
