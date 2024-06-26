// ignore_for_file: depend_on_referenced_packages

/* ====== Packages ====== */
export 'package:flutter/material.dart';
export 'package:flutter/gestures.dart';
export 'package:flutter/foundation.dart';

export 'dart:convert';
export 'dart:async';

export 'package:flutter_bootstrap5/flutter_bootstrap5.dart';
export 'package:get/get.dart';
export 'package:flutter_local_notifications/flutter_local_notifications.dart';
export 'package:font_awesome_flutter/font_awesome_flutter.dart';
export 'package:image_picker/image_picker.dart';
export 'package:phone_form_field/phone_form_field.dart';
export 'package:geolocator/geolocator.dart';
export 'package:flutter_map/flutter_map.dart';
export 'package:latlong2/latlong.dart' hide Path;
export 'package:carousel_slider/carousel_slider.dart';
export 'package:url_launcher/url_launcher.dart';
export 'package:multi_select_flutter/multi_select_flutter.dart';
export 'package:intl/intl.dart' hide TextDirection;

export 'firebase_options.dart';
export 'package:firebase_core/firebase_core.dart';
export 'package:firebase_auth/firebase_auth.dart';
export 'package:cloud_firestore/cloud_firestore.dart';
export 'package:firebase_messaging/firebase_messaging.dart';

/* ====== Components ====== */
export 'components/constants.dart';
export 'components/input.dart';
export 'components/order.dart';

/* ====== Models ====== */
export 'models/user.dart';
export 'models/team.dart';
export 'models/review.dart';
export 'models/category.dart';
export 'models/product.dart';
export 'models/order.dart';

/* ====== Helpers ====== */
export 'helper/binding.dart';
export 'helper/address.dart';
export 'helper/message.dart';
export 'helper/user.dart';
export 'helper/category.dart';
export 'helper/product.dart';
export 'helper/order.dart';

/* ====== Pages ====== */
export 'pages/home.dart';

// Auth
export 'pages/auth/widget.dart';
export 'pages/auth/sign_in.dart';
export 'pages/auth/sign_up.dart';
export 'pages/customer/profile.dart';

// Admin
export 'pages/admin/scaffold.dart';
export 'pages/admin/home.dart';
export 'pages/admin/menu/menu.dart';
export 'pages/admin/menu/category_edit.dart';
export 'pages/admin/menu/product_edit.dart';
export 'pages/admin/orders.dart';

// Customer
export 'pages/customer/scaffold.dart';
export 'pages/customer/home.dart';
export 'pages/customer/about.dart';
export 'pages/customer/menu/menu.dart';
export 'pages/customer/menu/product.dart';
export 'pages/customer/sections.dart';
export 'pages/customer/cart.dart';
export 'pages/customer/orders.dart';

// Driver
export 'pages/driver/scaffold.dart';
export 'pages/driver/home.dart';
export 'pages/driver/orders.dart';
