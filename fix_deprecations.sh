#!/bin/bash

# Fix withOpacity
find . -name "*.dart" -type f -exec sed -i 's/\.withOpacity($[^)]*$)/.withValues(alpha: \1)/g' {} +

# Fix WillPopScope
find . -name "*.dart" -type f -exec sed -i 's/WillPopScope/PopScope/g' {} +
find . -name "*.dart" -type f -exec sed -i 's/onWillPop:/canPop:/g' {} +

# Fix background color
find . -name "*.dart" -type f -exec sed -i 's/colorScheme\.background/colorScheme.surface/g' {} +
find . -name "*.dart" -type f -exec sed -i 's/colorScheme\.onBackground/colorScheme.onSurface/g' {} +

echo "Deprecations fixed!"