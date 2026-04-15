import React, { useState } from 'react';
import { View, Text, TextInput, TouchableOpacity, StyleSheet, ActivityIndicator, Alert } from 'react-native';
import { useRouter } from 'react-router-native'; // Wait, it's expo-router
import { useRouter as useExpoRouter } from 'react-router'; 
import { router } from 'expo-router';
import { useAuth } from '../../context/AuthContext';
import api from '../../utils/api';

export default function LoginScreen() {
  const [email, setEmail] = useState('');
  const [password, setPassword] = useState('');
  const [loading, setLoading] = useState(false);
  const { login } = useAuth();

  const handleLogin = async () => {
    if (!email || !password) {
      Alert.alert('Error', 'Please enter both email and password.');
      return;
    }
    setLoading(true);
    try {
      const response = await api.post('/auth/login', { email, password });
      await login(response.data.token, response.data.onboarding_completed);
      // Layout handles redirect
    } catch (e: any) {
      const msg = e.response?.data?.error || 'Login failed. Try again.';
      Alert.alert('Login Failed', msg);
    }
    setLoading(false);
  };

  return (
    <View style={styles.container}>
      <Text style={styles.title}>Welcome Back</Text>
      <Text style={styles.subtitle}>Log in to continue your fitness journey</Text>

      <TextInput
        style={styles.input}
        placeholder="Email"
        placeholderTextColor="#888"
        value={email}
        onChangeText={setEmail}
        autoCapitalize="none"
        keyboardType="email-address"
      />
      
      <TextInput
        style={styles.input}
        placeholder="Password"
        placeholderTextColor="#888"
        value={password}
        onChangeText={setPassword}
        secureTextEntry
      />

      <TouchableOpacity style={styles.button} onPress={handleLogin} disabled={loading}>
        {loading ? <ActivityIndicator color="#fff" /> : <Text style={styles.buttonText}>Log In</Text>}
      </TouchableOpacity>

      <TouchableOpacity onPress={() => router.push('/(auth)/signup')}>
        <Text style={styles.linkText}>Don't have an account? Sign up.</Text>
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
    backgroundColor: '#1C1C1E', color: '#fff', borderRadius: 12, padding: 16, fontSize: 16, marginBottom: 16,
  },
  button: {
    backgroundColor: '#3b82f6', padding: 16, borderRadius: 12, alignItems: 'center', marginTop: 8,
  },
  buttonText: {
    color: '#fff', fontSize: 16, fontWeight: 'bold'
  },
  linkText: {
    color: '#3b82f6', marginTop: 24, textAlign: 'center', fontSize: 14
  }
});
