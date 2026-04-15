import React, { useState } from 'react';
import { View, Text, TextInput, TouchableOpacity, StyleSheet, ActivityIndicator, Alert } from 'react-native';
import { useLocalSearchParams, useRouter } from 'react-router-native'; // Wait, let's use expo-router equivalents
import { useLocalSearchParams as useExpoParams, router } from 'expo-router';
import { useAuth } from '../../context/AuthContext';
import api from '../../utils/api';

export default function VerifyScreen() {
  const { email } = useExpoParams<{ email: string }>();
  const [otp, setOtp] = useState('');
  const [loading, setLoading] = useState(false);
  const { login } = useAuth();

  const handleVerify = async () => {
    if (!otp) {
      Alert.alert('Error', 'Please enter the verification code.');
      return;
    }
    setLoading(true);
    try {
      const response = await api.post('/auth/verify-otp', { email, otp });
      // Upon successful verification, they are logged in.
      await login(response.data.token, false);
      // Wait for layout to redirect to onboarding
    } catch (e: any) {
      const msg = e.response?.data?.error || 'Verification failed.';
      Alert.alert('Error', msg);
    }
    setLoading(false);
  };

  return (
    <View style={styles.container}>
      <Text style={styles.title}>Check your email</Text>
      <Text style={styles.subtitle}>We sent a verification code to {email}. Check your spam folder too.</Text>

      <TextInput
        style={styles.input}
        placeholder="6-digit code"
        placeholderTextColor="#888"
        keyboardType="numeric"
        value={otp}
        onChangeText={setOtp}
      />

      <TouchableOpacity style={styles.button} onPress={handleVerify} disabled={loading}>
        {loading ? <ActivityIndicator color="#fff" /> : <Text style={styles.buttonText}>Verify</Text>}
      </TouchableOpacity>
    </View>
  );
}

const styles = StyleSheet.create({
    container: {
      flex: 1, backgroundColor: '#0A0A0A', padding: 24, justifyContent: 'center',
    },
    title: {
      fontSize: 32, fontWeight: '800', color: '#fff', marginBottom: 8,
    },
    subtitle: {
      fontSize: 16, color: '#A1A1AA', marginBottom: 32,
    },
    input: {
      backgroundColor: '#1C1C1E', color: '#fff', borderRadius: 12, padding: 16, fontSize: 16, marginBottom: 16, textAlign: 'center', letterSpacing: 8
    },
    button: {
      backgroundColor: '#3b82f6', padding: 16, borderRadius: 12, alignItems: 'center', marginTop: 8,
    },
    buttonText: {
      color: '#fff', fontSize: 16, fontWeight: 'bold'
    }
});
