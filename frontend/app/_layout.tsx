import { AuthProvider, useAuth } from '../context/AuthContext';
import { Stack, useRouter, useSegments } from 'expo-router';
import { useEffect } from 'react';

function InitialLayout() {
  const { token, isLoading, onboardingCompleted } = useAuth();
  const segments = useSegments();
  const router = useRouter();

  useEffect(() => {
    if (isLoading) return;

    const inAuthGroup = segments[1] === '(auth)';
    
    if (!token && !inAuthGroup) {
      router.replace('/(auth)/login');
    } else if (token) {
      if (!onboardingCompleted && segments[1] !== '(auth)' && segments[2] !== 'onboarding') {
          router.replace('/(auth)/onboarding');
      } else if (onboardingCompleted && inAuthGroup) {
          router.replace('/(tabs)/dashboard');
      }
    }
  }, [token, isLoading, onboardingCompleted, segments]);

  return (
    <Stack>
      <Stack.Screen name="(auth)" options={{ headerShown: false }} />
      <Stack.Screen name="(tabs)" options={{ headerShown: false }} />
    </Stack>
  );
}

export default function RootLayout() {
  return (
    <AuthProvider>
      <InitialLayout />
    </AuthProvider>
  );
}
