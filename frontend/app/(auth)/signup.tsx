import React, { useState } from 'react';
import { View, Text, TextInput, TouchableOpacity, StyleSheet, ActivityIndicator, Alert, ScrollView } from 'react-native';
import { router } from 'expo-router';
import api from '../../utils/api';
import { Ionicons } from '@expo/vector-icons';

export default function SignupScreen() {
  const [form, setForm] = useState({ name: '', age: '', weight: '', email: '', password: '', confirm: '' });
  const [loading, setLoading] = useState(false);
  const [showPassword, setShowPassword] = useState(false);

  const handleSignup = async () => {
    if (!form.name || !form.age || !form.weight || !form.email || !form.password || !form.confirm) {
      Alert.alert('Error', 'All fields are required.');
      return;
    }
    if (form.password !== form.confirm) {
      Alert.alert('Error', 'Passwords do not match.');
      return;
    }
    setLoading(true);
    try {
      await api.post('/auth/signup', {
        name: form.name,
        age: parseInt(form.age),
        weight: parseInt(form.weight),
        email: form.email,
        password: form.password
      });
      router.push({ pathname: '/(auth)/verify', params: { email: form.email } });
    } catch (e: any) {
      const msg = e.response?.data?.error || 'Signup failed.';
      Alert.alert('Error', msg);
    }
    setLoading(false);
  };

  return (
    <ScrollView contentContainerStyle={styles.container}>
      <Text style={styles.title}>Create Account</Text>

      <TextInput style={styles.input} placeholder="Full Name" placeholderTextColor="#888" value={form.name} onChangeText={(val) => setForm({ ...form, name: val })} />
      <TextInput style={styles.input} placeholder="Age" placeholderTextColor="#888" keyboardType="numeric" value={form.age} onChangeText={(val) => setForm({ ...form, age: val })} />
      <TextInput style={styles.input} placeholder="Weight (kg)" placeholderTextColor="#888" keyboardType="numeric" value={form.weight} onChangeText={(val) => setForm({ ...form, weight: val })} />
      <TextInput style={styles.input} placeholder="Email" placeholderTextColor="#888" autoCapitalize="none" keyboardType="email-address" value={form.email} onChangeText={(val) => setForm({ ...form, email: val })} />
      
      <View style={styles.passwordContainer}>
        <TextInput style={[styles.input, { flex: 1, marginBottom: 0 }]} placeholder="Password" placeholderTextColor="#888" secureTextEntry={!showPassword} value={form.password} onChangeText={(val) => setForm({ ...form, password: val })} />
        <TouchableOpacity style={styles.eyeIcon} onPress={() => setShowPassword(!showPassword)}>
          <Ionicons name={showPassword ? "eye-off" : "eye"} size={24} color="#888" />
        </TouchableOpacity>
      </View>

      <TextInput style={styles.input} placeholder="Confirm Password" placeholderTextColor="#888" secureTextEntry={!showPassword} value={form.confirm} onChangeText={(val) => setForm({ ...form, confirm: val })} />

      <TouchableOpacity style={styles.button} onPress={handleSignup} disabled={loading}>
        {loading ? <ActivityIndicator color="#fff" /> : <Text style={styles.buttonText}>Sign Up</Text>}
      </TouchableOpacity>
    </ScrollView>
  );
}

const styles = StyleSheet.create({
  container: {
    flexGrow: 1, backgroundColor: '#0A0A0A', padding: 24, justifyContent: 'center',
  },
  title: {
    fontSize: 32, fontWeight: '800', color: '#fff', marginBottom: 32,
  },
  input: {
    backgroundColor: '#1C1C1E', color: '#fff', borderRadius: 12, padding: 16, fontSize: 16, marginBottom: 16,
  },
  passwordContainer: {
    flexDirection: 'row', alignItems: 'center', backgroundColor: '#1C1C1E', borderRadius: 12, marginBottom: 16,
  },
  eyeIcon: {
    padding: 16,
  },
  button: {
    backgroundColor: '#3b82f6', padding: 16, borderRadius: 12, alignItems: 'center', marginTop: 16,
  },
  buttonText: {
    color: '#fff', fontSize: 16, fontWeight: 'bold'
  }
});
