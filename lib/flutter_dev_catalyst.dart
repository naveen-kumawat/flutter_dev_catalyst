library flutter_dev_catalyst;

// Core API
export 'src/core/api/api_client.dart';
export 'src/core/api/api_config.dart';
export 'src/core/api/api_response.dart';
export 'src/core/api/api_interceptor.dart';

// Storage
export 'src/core/storage/storage_service.dart';
export 'src/core/storage/secure_storage_service.dart';
export 'src/core/storage/cache_manager.dart';

// Network
export 'src/core/network/connectivity_service.dart';

// Error Handling
export 'src/core/error/error_handler.dart';
export 'src/core/error/exceptions.dart';
export 'src/core/error/failures.dart';

// Dependency Injection
export 'src/core/di/service_locator.dart';

// UI Components
export 'src/ui/responsive/responsive_builder.dart';
export 'src/ui/responsive/screen_util.dart';
export 'src/ui/widgets/catalyst_button.dart';
export 'src/ui/widgets/catalyst_text_field.dart';
export 'src/ui/widgets/catalyst_loading.dart';
export 'src/ui/widgets/catalyst_error_widget.dart';
export 'src/ui/theme/theme_manager.dart';
export 'src/ui/theme/app_theme.dart';

// Utils
export 'src/utils/validators/validators.dart';
export 'src/utils/logger/catalyst_logger.dart';
export 'src/utils/extensions/string_extensions.dart';
export 'src/utils/extensions/widget_extensions.dart';
export 'src/utils/extensions/context_extensions.dart';
export 'src/utils/helpers/date_helper.dart';
export 'src/utils/helpers/format_helper.dart';

// Models
export 'src/models/api_error.dart';
export 'src/models/pagination.dart';

// Main Catalyst Class
export 'src/dev_catalyst.dart';
