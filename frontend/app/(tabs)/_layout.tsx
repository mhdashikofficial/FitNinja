import { Tabs } from 'expo-router';
import { Ionicons } from '@expo/vector-icons';

export default function TabLayout() {
  return (
    <Tabs screenOptions={{
        headerTitleStyle: { color: '#fff' },
        headerStyle: { backgroundColor: '#0A0A0A' },
        tabBarStyle: { backgroundColor: '#0A0A0A', borderTopColor: '#222' },
        tabBarActiveTintColor: '#3b82f6',
        tabBarInactiveTintColor: '#888'
    }}>
      <Tabs.Screen 
        name="dashboard" 
        options={{ 
            title: 'AI Plan', 
            tabBarIcon: ({ color }) => <Ionicons name="calendar" size={24} color={color} /> 
        }} 
      />
      <Tabs.Screen 
        name="tracker" 
        options={{ 
            title: 'Boxing Tracker', 
            tabBarIcon: ({ color }) => <Ionicons name="body" size={24} color={color} /> 
        }} 
      />
    </Tabs>
  );
}
