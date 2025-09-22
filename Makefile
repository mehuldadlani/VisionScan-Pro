# VisionScan Pro - Professional Flutter OCR Application
# Makefile for development, build, and deployment tasks

# Project Configuration
PROJECT_NAME := visionscan_pro
PACKAGE_NAME := com.visionscan.pro
VERSION := 1.0.0
BUILD_NUMBER := 1

# Flutter Configuration
FLUTTER := flutter
DART := dart
BUILD_RUNNER := $(FLUTTER) packages pub run build_runner

# Directories
LIB_DIR := lib
TEST_DIR := test
ASSETS_DIR := assets
DOCS_DIR := docs
BUILD_DIR := build
GENERATED_DIR := generated

# Colors for output
RED := \033[0;31m
GREEN := \033[0;32m
YELLOW := \033[0;33m
BLUE := \033[0;34m
PURPLE := \033[0;35m
CYAN := \033[0;36m
WHITE := \033[0;37m
NC := \033[0m # No Color

# Default target
.DEFAULT_GOAL := help

# Help target - shows all available commands
.PHONY: help
help: ## Show this help message
	@echo "$(CYAN)VisionScan Pro - Professional Flutter OCR Application$(NC)"
	@echo "$(YELLOW)Available commands:$(NC)"
	@echo ""
	@grep -E '^[a-zA-Z_-]+:.*?## .*$$' $(MAKEFILE_LIST) | sort | awk 'BEGIN {FS = ":.*?## "}; {printf "  $(GREEN)%-20s$(NC) %s\n", $$1, $$2}'
	@echo ""

# Development Commands
.PHONY: setup
setup: ## Initial project setup and dependency installation
	@echo "$(BLUE)Setting up VisionScan Pro project...$(NC)"
	$(FLUTTER) clean
	$(FLUTTER) pub get
	$(FLUTTER) pub upgrade
	@echo "$(GREEN)Project setup completed!$(NC)"

.PHONY: deps
deps: ## Install and update dependencies
	@echo "$(BLUE)Installing dependencies...$(NC)"
	$(FLUTTER) pub get
	$(FLUTTER) pub upgrade
	@echo "$(GREEN)Dependencies updated!$(NC)"

.PHONY: clean
clean: ## Clean build artifacts and generated files
	@echo "$(BLUE)Cleaning project...$(NC)"
	$(FLUTTER) clean
	rm -rf $(BUILD_DIR)
	rm -rf $(GENERATED_DIR)
	find . -name "*.g.dart" -delete
	find . -name "*.freezed.dart" -delete
	find . -name "*.gr.dart" -delete
	@echo "$(GREEN)Project cleaned!$(NC)"

# Code Generation Commands
.PHONY: generate
generate: ## Generate all code (freezed, json_serializable, riverpod, etc.)
	@echo "$(BLUE)Generating code...$(NC)"
	$(BUILD_RUNNER) build --delete-conflicting-outputs
	@echo "$(GREEN)Code generation completed!$(NC)"

.PHONY: generate-watch
generate-watch: ## Watch for changes and auto-generate code
	@echo "$(BLUE)Starting code generation watcher...$(NC)"
	$(BUILD_RUNNER) watch --delete-conflicting-outputs

.PHONY: generate-clean
generate-clean: ## Clean and regenerate all code
	@echo "$(BLUE)Cleaning and regenerating code...$(NC)"
	$(BUILD_RUNNER) clean
	$(BUILD_RUNNER) build --delete-conflicting-outputs
	@echo "$(GREEN)Code regeneration completed!$(NC)"

# Analysis and Linting Commands
.PHONY: analyze
analyze: ## Run static analysis
	@echo "$(BLUE)Running static analysis...$(NC)"
	$(FLUTTER) analyze
	@echo "$(GREEN)Analysis completed!$(NC)"

.PHONY: format
format: ## Format all Dart code
	@echo "$(BLUE)Formatting code...$(NC)"
	$(FLUTTER) format $(LIB_DIR) $(TEST_DIR)
	@echo "$(GREEN)Code formatted!$(NC)"

.PHONY: format-check
format-check: ## Check if code is properly formatted
	@echo "$(BLUE)Checking code formatting...$(NC)"
	$(FLUTTER) format --dry-run $(LIB_DIR) $(TEST_DIR)

.PHONY: lint
lint: ## Run linting checks
	@echo "$(BLUE)Running linting...$(NC)"
	$(DART) run very_good_analysis
	@echo "$(GREEN)Linting completed!$(NC)"

# Testing Commands
.PHONY: test
test: ## Run all tests
	@echo "$(BLUE)Running tests...$(NC)"
	$(FLUTTER) test
	@echo "$(GREEN)Tests completed!$(NC)"

.PHONY: test-coverage
test-coverage: ## Run tests with coverage
	@echo "$(BLUE)Running tests with coverage...$(NC)"
	$(FLUTTER) test --coverage
	@echo "$(GREEN)Test coverage generated!$(NC)"

.PHONY: test-watch
test-watch: ## Run tests in watch mode
	@echo "$(BLUE)Starting test watcher...$(NC)"
	$(FLUTTER) test --watch

.PHONY: test-integration
test-integration: ## Run integration tests
	@echo "$(BLUE)Running integration tests...$(NC)"
	$(FLUTTER) test integration_test/
	@echo "$(GREEN)Integration tests completed!$(NC)"

# Build Commands
.PHONY: build-apk
build-apk: ## Build APK for Android
	@echo "$(BLUE)Building APK...$(NC)"
	$(FLUTTER) build apk --release
	@echo "$(GREEN)APK built successfully!$(NC)"

.PHONY: build-aab
build-aab: ## Build Android App Bundle
	@echo "$(BLUE)Building Android App Bundle...$(NC)"
	$(FLUTTER) build appbundle --release
	@echo "$(GREEN)Android App Bundle built successfully!$(NC)"

.PHONY: build-ios
build-ios: ## Build iOS app
	@echo "$(BLUE)Building iOS app...$(NC)"
	$(FLUTTER) build ios --release --no-codesign
	@echo "$(GREEN)iOS app built successfully!$(NC)"

.PHONY: build-web
build-web: ## Build web app
	@echo "$(BLUE)Building web app...$(NC)"
	$(FLUTTER) build web --release
	@echo "$(GREEN)Web app built successfully!$(NC)"

.PHONY: build-all
build-all: ## Build for all platforms
	@echo "$(BLUE)Building for all platforms...$(NC)"
	$(MAKE) build-apk
	$(MAKE) build-aab
	$(MAKE) build-ios
	$(MAKE) build-web
	@echo "$(GREEN)All builds completed!$(NC)"

# Development Build Commands
.PHONY: build-debug
build-debug: ## Build debug APK
	@echo "$(BLUE)Building debug APK...$(NC)"
	$(FLUTTER) build apk --debug
	@echo "$(GREEN)Debug APK built successfully!$(NC)"

.PHONY: build-profile
build-profile: ## Build profile APK
	@echo "$(BLUE)Building profile APK...$(NC)"
	$(FLUTTER) build apk --profile
	@echo "$(GREEN)Profile APK built successfully!$(NC)"

# Run Commands
.PHONY: run
run: ## Run the app in debug mode
	@echo "$(BLUE)Running app...$(NC)"
	$(FLUTTER) run

.PHONY: run-release
run-release: ## Run the app in release mode
	@echo "$(BLUE)Running app in release mode...$(NC)"
	$(FLUTTER) run --release

.PHONY: run-profile
run-profile: ## Run the app in profile mode
	@echo "$(BLUE)Running app in profile mode...$(NC)"
	$(FLUTTER) run --profile

.PHONY: run-web
run-web: ## Run the app on web
	@echo "$(BLUE)Running app on web...$(NC)"
	$(FLUTTER) run -d web-server --web-port 8080

# Device Commands
.PHONY: devices
devices: ## List available devices
	@echo "$(BLUE)Available devices:$(NC)"
	$(FLUTTER) devices

.PHONY: doctor
doctor: ## Run Flutter doctor
	@echo "$(BLUE)Running Flutter doctor...$(NC)"
	$(FLUTTER) doctor -v

# Asset Commands
.PHONY: assets
assets: ## Generate asset files
	@echo "$(BLUE)Generating assets...$(NC)"
	$(FLUTTER) packages pub run build_runner build --delete-conflicting-outputs
	@echo "$(GREEN)Assets generated!$(NC)"

.PHONY: icons
icons: ## Generate app icons
	@echo "$(BLUE)Generating app icons...$(NC)"
	$(FLUTTER) packages pub run flutter_launcher_icons:main
	@echo "$(GREEN)App icons generated!$(NC)"

# Documentation Commands
.PHONY: docs
docs: ## Generate documentation
	@echo "$(BLUE)Generating documentation...$(NC)"
	$(DART) doc $(LIB_DIR) --output $(DOCS_DIR)
	@echo "$(GREEN)Documentation generated in $(DOCS_DIR)/$(NC)"

.PHONY: docs-serve
docs-serve: ## Serve documentation locally
	@echo "$(BLUE)Serving documentation...$(NC)"
	$(DART) doc serve $(LIB_DIR) --port 8080

# Quality Assurance Commands
.PHONY: qa
qa: ## Run full quality assurance checks
	@echo "$(BLUE)Running quality assurance checks...$(NC)"
	$(MAKE) clean
	$(MAKE) generate
	$(MAKE) format
	$(MAKE) analyze
	$(MAKE) lint
	$(MAKE) test
	@echo "$(GREEN)Quality assurance checks completed!$(NC)"

.PHONY: pre-commit
pre-commit: ## Run pre-commit checks
	@echo "$(BLUE)Running pre-commit checks...$(NC)"
	$(MAKE) format
	$(MAKE) analyze
	$(MAKE) test
	@echo "$(GREEN)Pre-commit checks completed!$(NC)"

# Deployment Commands
.PHONY: deploy-android
deploy-android: ## Deploy to Android (requires device/emulator)
	@echo "$(BLUE)Deploying to Android...$(NC)"
	$(FLUTTER) install

.PHONY: deploy-ios
deploy-ios: ## Deploy to iOS (requires device/simulator)
	@echo "$(BLUE)Deploying to iOS...$(NC)"
	$(FLUTTER) install

# Maintenance Commands
.PHONY: upgrade
upgrade: ## Upgrade Flutter and dependencies
	@echo "$(BLUE)Upgrading Flutter and dependencies...$(NC)"
	$(FLUTTER) upgrade
	$(FLUTTER) pub upgrade
	@echo "$(GREEN)Upgrade completed!$(NC)"

.PHONY: outdated
outdated: ## Check for outdated dependencies
	@echo "$(BLUE)Checking for outdated dependencies...$(NC)"
	$(FLUTTER) pub outdated

.PHONY: pub-cache-repair
pub-cache-repair: ## Repair pub cache
	@echo "$(BLUE)Repairing pub cache...$(NC)"
	$(FLUTTER) pub cache repair
	@echo "$(GREEN)Pub cache repaired!$(NC)"

# Database Commands
.PHONY: db-reset
db-reset: ## Reset ObjectBox database
	@echo "$(BLUE)Resetting ObjectBox database...$(NC)"
	rm -rf $(BUILD_DIR)/app_documents/objectbox
	@echo "$(GREEN)Database reset completed!$(NC)"

# Performance Commands
.PHONY: profile
profile: ## Run performance profiling
	@echo "$(BLUE)Running performance profiling...$(NC)"
	$(FLUTTER) run --profile --trace-startup

.PHONY: benchmark
benchmark: ## Run performance benchmarks
	@echo "$(BLUE)Running performance benchmarks...$(NC)"
	$(FLUTTER) test test/benchmarks/

# Security Commands
.PHONY: security-scan
security-scan: ## Run security scan
	@echo "$(BLUE)Running security scan...$(NC)"
	$(DART) pub global activate security_scanner
	$(DART) pub global run security_scanner
	@echo "$(GREEN)Security scan completed!$(NC)"

# Release Commands
.PHONY: release-prepare
release-prepare: ## Prepare for release
	@echo "$(BLUE)Preparing for release...$(NC)"
	$(MAKE) clean
	$(MAKE) generate
	$(MAKE) qa
	$(MAKE) build-all
	@echo "$(GREEN)Release preparation completed!$(NC)"

.PHONY: release-version
release-version: ## Update version number
	@echo "$(BLUE)Updating version to $(VERSION)+$(BUILD_NUMBER)...$(NC)"
	$(FLUTTER) pub version $(VERSION)+$(BUILD_NUMBER)
	@echo "$(GREEN)Version updated!$(NC)"

# Utility Commands
.PHONY: size
size: ## Analyze app size
	@echo "$(BLUE)Analyzing app size...$(NC)"
	$(FLUTTER) build apk --analyze-size
	@echo "$(GREEN)Size analysis completed!$(NC)"

.PHONY: tree
tree: ## Show dependency tree
	@echo "$(BLUE)Dependency tree:$(NC)"
	$(FLUTTER) pub deps

.PHONY: info
info: ## Show project information
	@echo "$(CYAN)VisionScan Pro - Project Information$(NC)"
	@echo "$(YELLOW)Project Name:$(NC) $(PROJECT_NAME)"
	@echo "$(YELLOW)Package Name:$(NC) $(PACKAGE_NAME)"
	@echo "$(YELLOW)Version:$(NC) $(VERSION)+$(BUILD_NUMBER)"
	@echo "$(YELLOW)Flutter Version:$(NC) $$($(FLUTTER) --version | head -n 1)"
	@echo "$(YELLOW)Dart Version:$(NC) $$($(DART) --version | head -n 1)"

# Development Workflow
.PHONY: dev
dev: ## Start development workflow
	@echo "$(BLUE)Starting development workflow...$(NC)"
	$(MAKE) setup
	$(MAKE) generate
	$(MAKE) run

.PHONY: ci
ci: ## Run CI/CD pipeline
	@echo "$(BLUE)Running CI/CD pipeline...$(NC)"
	$(MAKE) clean
	$(MAKE) generate
	$(MAKE) format-check
	$(MAKE) analyze
	$(MAKE) lint
	$(MAKE) test
	$(MAKE) build-apk
	@echo "$(GREEN)CI/CD pipeline completed!$(NC)"

# Cleanup Commands
.PHONY: deep-clean
deep-clean: ## Deep clean everything
	@echo "$(BLUE)Performing deep clean...$(NC)"
	$(FLUTTER) clean
	rm -rf $(BUILD_DIR)
	rm -rf $(GENERATED_DIR)
	rm -rf .dart_tool
	rm -rf .packages
	rm -rf pubspec.lock
	find . -name "*.g.dart" -delete
	find . -name "*.freezed.dart" -delete
	find . -name "*.gr.dart" -delete
	$(FLUTTER) pub get
	@echo "$(GREEN)Deep clean completed!$(NC)"

# Show current status
.PHONY: status
status: ## Show current project status
	@echo "$(CYAN)VisionScan Pro - Project Status$(NC)"
	@echo "$(YELLOW)Flutter Doctor:$(NC)"
	@$(FLUTTER) doctor --no-version-check
	@echo ""
	@echo "$(YELLOW)Available Devices:$(NC)"
	@$(FLUTTER) devices --no-version-check
	@echo ""
	@echo "$(YELLOW)Project Dependencies:$(NC)"
	@$(FLUTTER) pub deps --no-dev

# Show this help by default
.PHONY: all
all: help
