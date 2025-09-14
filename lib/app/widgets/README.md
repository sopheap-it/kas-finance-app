# Reusable Widgets

This folder contains reusable UI components that can be used throughout the KAS Finance app to maintain consistency and reduce code duplication.

## Available Widgets

### 1. CustomFormField
A customizable form field with built-in styling, icons, and validation support.

```dart
CustomFormField(
  controller: _emailController,
  label: 'Email',
  hint: 'Enter your email',
  icon: Icons.email_outlined,
  keyboardType: TextInputType.emailAddress,
  validator: (value) {
    if (value == null || value.isEmpty) {
      return 'Please enter your email';
    }
    return null;
  },
)
```

**Properties:**
- `controller`: TextEditingController for the field
- `label`: Label text above the field
- `hint`: Placeholder text inside the field
- `icon`: Icon displayed in the prefix
- `isPassword`: Whether this is a password field
- `isConfirmPassword`: Whether this is a confirm password field
- `keyboardType`: Type of keyboard to show
- `validator`: Form validation function
- `enabled`: Whether the field is enabled
- `maxLines`: Maximum number of lines
- `maxLength`: Maximum character length

### 2. PrimaryButton
A primary action button with gradient background and loading state.

```dart
PrimaryButton(
  text: 'Sign In',
  onPressed: _signIn,
  isLoading: authProvider.isLoading,
  icon: Icons.login,
)
```

**Properties:**
- `text`: Button text
- `onPressed`: Callback when button is pressed
- `isLoading`: Whether to show loading state
- `isFullWidth`: Whether button spans full width
- `height`: Button height
- `borderRadius`: Corner radius
- `icon`: Optional icon to display
- `textColor`: Custom text color
- `fontSize`: Custom font size
- `fontWeight`: Custom font weight

### 3. SecondaryButton
A secondary/outlined button with customizable styling.

```dart
SecondaryButton(
  text: 'Continue as Guest',
  onPressed: _continueAsGuest,
  icon: Icons.explore_outlined,
)
```

**Properties:**
- `text`: Button text
- `onPressed`: Callback when button is pressed
- `isFullWidth`: Whether button spans full width
- `height`: Button height
- `borderRadius`: Corner radius
- `icon`: Optional icon to display
- `color`: Custom color
- `borderColor`: Custom border color
- `textColor`: Custom text color
- `fontSize`: Custom font size
- `fontWeight`: Custom font weight
- `isLoading`: Whether to show loading state

### 4. SocialButton
A button designed for social login (Google, Apple, etc.).

```dart
SocialButton(
  onPressed: _signInWithGoogle,
  icon: Icons.g_mobiledata,
  label: 'Google',
  color: const Color(0xFFDB4437),
)
```

**Properties:**
- `onPressed`: Callback when button is pressed
- `icon`: Social platform icon
- `label`: Button label
- `color`: Brand color
- `isFullWidth`: Whether button spans full width
- `height`: Button height
- `borderRadius`: Corner radius
- `isLoading`: Whether to show loading state

### 5. CustomCheckbox
A checkbox with optional link text support.

```dart
CustomCheckbox(
  value: _agreeToTerms,
  onChanged: (value) => setState(() => _agreeToTerms = value ?? false),
  label: 'I agree to the ',
  linkText: 'Terms of Service',
  onLinkTap: () => _showTermsDialog(),
)
```

**Properties:**
- `value`: Current checkbox state
- `onChanged`: Callback when checkbox state changes
- `label`: Label text
- `linkText`: Optional clickable link text
- `onLinkTap`: Callback when link is tapped
- `activeColor`: Custom active color
- `size`: Custom checkbox size
- `enabled`: Whether the checkbox is enabled

### 6. CustomDivider
A divider with centered text and gradient lines.

```dart
CustomDivider(
  text: 'OR',
  color: theme.colorScheme.onSurface,
)
```

**Properties:**
- `text`: Text to display in the center
- `color`: Color for the divider lines
- `thickness`: Line thickness
- `padding`: Padding around the text
- `textStyle`: Custom text styling

### 7. CustomTextButton
A customizable text button for secondary actions like links.

```dart
CustomTextButton(
  text: 'Forgot Password?',
  onPressed: _showForgotPasswordDialog,
  textColor: theme.colorScheme.primary,
  fontSize: 14,
)
```

**Properties:**
- `text`: Button text
- `onPressed`: Callback when button is pressed
- `textColor`: Custom text color
- `fontSize`: Custom font size
- `fontWeight`: Custom font weight
- `decoration`: Text decoration (underline, etc.)
- `padding`: Custom padding
- `enabled`: Whether the button is enabled

## Usage

Import the widgets using:

```dart
import '../../app/widgets/index.dart';
```

Or import individual widgets:

```dart
import '../../app/widgets/custom_form_field.dart';
```

## Benefits

1. **Consistency**: All forms and buttons look the same across the app
2. **Maintainability**: Changes to styling only need to be made in one place
3. **Reusability**: Easy to use the same components in different screens
4. **Customization**: Flexible properties allow for different use cases
5. **Accessibility**: Built-in support for proper accessibility features

## Best Practices

1. Always use these widgets instead of creating custom form fields or buttons
2. Customize using the provided properties rather than modifying the widget code
3. Keep the widgets focused on a single responsibility
4. Test widgets with different themes and screen sizes
5. Document any new properties or changes
