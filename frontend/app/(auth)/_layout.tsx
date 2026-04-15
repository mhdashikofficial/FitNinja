import { Stack } from 'expo-router';

export default function AuthLayout() {
  return (
    <Stack>
      <Stack.Screen name="login" options={{ title: 'Login' }} />
      <Stack.Screen name="signup" options={{ title: 'Sign Up' }} />
      <Stack.Screen name="verify" options={{ title: 'Verify Email' }} />
      <Stack.Screen name="onboarding" options={{ title: 'Complete Profile' }} />
    </Stack>
  );
}
