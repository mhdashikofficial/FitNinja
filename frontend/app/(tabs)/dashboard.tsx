import React, { useEffect, useState } from 'react';
import { View, Text, StyleSheet, ScrollView, ActivityIndicator, TouchableOpacity } from 'react-native';
import api from '../../utils/api';
import { useAuth } from '../../context/AuthContext';

type PlanType = {
    food_plan: string;
    workout_plan: string;
    boxing_drills: string[];
};

export default function DashboardScreen() {
    const [plan, setPlan] = useState<PlanType | null>(null);
    const [loading, setLoading] = useState(true);
    const { logout } = useAuth();

    useEffect(() => {
        fetchPlan();
    }, []);

    const fetchPlan = async () => {
        setLoading(true);
        try {
            const resp = await api.get('/ai/generate-plan');
            setPlan(resp.data.plan);
        } catch (e) {
            console.log("Failed fetching plan:", e);
        }
        setLoading(false);
    };

    if (loading) {
        return (
            <View style={styles.center}>
                <ActivityIndicator size="large" color="#3b82f6" />
                <Text style={{color: '#888', marginTop: 12}}>NVIDIA AI is analyzing your profile...</Text>
            </View>
        );
    }

    return (
        <ScrollView style={styles.container}>
            <View style={styles.header}>
                <Text style={styles.greeting}>Daily Protocol Active</Text>
                <TouchableOpacity onPress={logout}><Text style={styles.logoutText}>Logout</Text></TouchableOpacity>
            </View>

            <View style={styles.card}>
                <Text style={styles.cardTitle}>Nutrition Core 🍏</Text>
                <Text style={styles.cardContent}>{plan?.food_plan || "Loading meal plan..."}</Text>
            </View>

            <View style={styles.card}>
                <Text style={styles.cardTitle}>Physical Protocol 💪</Text>
                <Text style={styles.cardContent}>{plan?.workout_plan || "Loading workout plan..."}</Text>
            </View>

            <View style={styles.card}>
                <Text style={styles.cardTitle}>Combat Drills 🥊</Text>
                {plan?.boxing_drills?.map((drill, idx) => (
                    <Text key={idx} style={styles.drillItem}>• {drill}</Text>
                ))}
            </View>

            <TouchableOpacity style={styles.refreshButton} onPress={fetchPlan}>
                <Text style={styles.refreshButtonText}>Regenerate AI Plan</Text>
            </TouchableOpacity>
        </ScrollView>
    );
}

const styles = StyleSheet.create({
    center: { flex: 1, backgroundColor: '#0A0A0A', justifyContent: 'center', alignItems: 'center' },
    container: { flex: 1, backgroundColor: '#0A0A0A', padding: 24 },
    header: { flexDirection: 'row', justifyContent: 'space-between', alignItems: 'center', marginBottom: 24, marginTop: 12 },
    greeting: { fontSize: 24, fontWeight: 'bold', color: '#fff' },
    logoutText: { color: '#ef4444', fontWeight: 'bold' },
    card: { backgroundColor: '#1C1C1E', borderRadius: 16, padding: 20, marginBottom: 16, borderWidth: 1, borderColor: '#222' },
    cardTitle: { fontSize: 18, fontWeight: 'bold', color: '#3b82f6', marginBottom: 8 },
    cardContent: { color: '#D4D4D8', fontSize: 16, lineHeight: 24 },
    drillItem: { color: '#E4E4E7', fontSize: 16, marginVertical: 4, fontWeight: '600' },
    refreshButton: { backgroundColor: '#222', padding: 16, borderRadius: 12, alignItems: 'center', marginVertical: 24 },
    refreshButtonText: { color: '#A1A1AA', fontWeight: 'bold' }
});
