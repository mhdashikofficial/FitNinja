import React, { useState } from 'react';
import { View, Text, TextInput, TouchableOpacity, StyleSheet, ActivityIndicator, ScrollView } from 'react-native';
import { router } from 'expo-router';
import { useAuth } from '../../context/AuthContext';
import api from '../../utils/api';

const EQUIPMENT_OPTIONS = ["Dumbbells", "Stretching bands", "Punching bag", "Gloves", "Pull-up bar", "Kettlebell"];

export default function OnboardingScreen() {
  const [step, setStep] = useState(1);
  const [location, setLocation] = useState('');
  const [workoutTime, setWorkoutTime] = useState('');
  const [equipment, setEquipment] = useState<string[]>([]);
  const [loading, setLoading] = useState(false);
  const { completeOnboarding } = useAuth();

  const toggleEquipment = (item: string) => {
    if (equipment.includes(item)) {
        setEquipment(equipment.filter(e => e !== item));
    } else {
        setEquipment([...equipment, item]);
    }
  };

  const handleFinish = async () => {
    setLoading(true);
    try {
      await api.post('/onboarding', { location, workout_time: workoutTime, equipment });
      await completeOnboarding();
      // Layout handles redirect
    } catch (e) {
      console.log(e);
    }
    setLoading(false);
  };

  return (
    <View style={styles.container}>
        {step === 1 && (
            <View style={styles.slide}>
                <Text style={styles.title}>Where are you located?</Text>
                <TextInput style={styles.input} placeholder="City, Country" placeholderTextColor="#888" value={location} onChangeText={setLocation} />
                <TouchableOpacity style={styles.button} onPress={() => setStep(2)}><Text style={styles.buttonText}>Next</Text></TouchableOpacity>
            </View>
        )}
        {step === 2 && (
            <View style={styles.slide}>
                <Text style={styles.title}>Preferred Workout Time?</Text>
                <Text style={styles.subtitle}>We'll use this to set up your daily reminder alarm.</Text>
                <TextInput style={styles.input} placeholder="e.g. 07:00 AM" placeholderTextColor="#888" value={workoutTime} onChangeText={setWorkoutTime} />
                <TouchableOpacity style={styles.button} onPress={() => setStep(3)}><Text style={styles.buttonText}>Next</Text></TouchableOpacity>
            </View>
        )}
        {step === 3 && (
            <View style={styles.slide}>
                <Text style={styles.title}>What equipment do you have at home?</Text>
                <ScrollView contentContainerStyle={styles.grid}>
                    {EQUIPMENT_OPTIONS.map((item) => {
                        const isSelected = equipment.includes(item);
                        return (
                            <TouchableOpacity key={item} style={[styles.pill, isSelected && styles.pillSelected]} onPress={() => toggleEquipment(item)}>
                                <Text style={[styles.pillText, isSelected && styles.pillTextSelected]}>{item}</Text>
                            </TouchableOpacity>
                        );
                    })}
                </ScrollView>
                <TouchableOpacity style={styles.button} onPress={handleFinish} disabled={loading}>
                    {loading ? <ActivityIndicator color="#fff" /> : <Text style={styles.buttonText}>Finish Setup</Text>}
                </TouchableOpacity>
            </View>
        )}
    </View>
  );
}

const styles = StyleSheet.create({
    container: { flex: 1, backgroundColor: '#0A0A0A', padding: 24, justifyContent: 'center' },
    slide: { flex: 1, justifyContent: 'center' },
    title: { fontSize: 32, fontWeight: '800', color: '#fff', marginBottom: 16 },
    subtitle: { fontSize: 16, color: '#A1A1AA', marginBottom: 24 },
    input: { backgroundColor: '#1C1C1E', color: '#fff', borderRadius: 12, padding: 16, fontSize: 16, marginBottom: 16 },
    button: { backgroundColor: '#3b82f6', padding: 16, borderRadius: 12, alignItems: 'center', marginTop: 16 },
    buttonText: { color: '#fff', fontSize: 16, fontWeight: 'bold' },
    grid: { flexDirection: 'row', flexWrap: 'wrap', marginBottom: 24 },
    pill: { backgroundColor: '#1C1C1E', paddingVertical: 12, paddingHorizontal: 20, borderRadius: 24, margin: 6, borderWidth: 1, borderColor: '#333' },
    pillSelected: { backgroundColor: '#3b82f6', borderColor: '#3b82f6' },
    pillText: { color: '#A1A1AA', fontSize: 16 },
    pillTextSelected: { color: '#fff', fontWeight: 'bold' }
});
