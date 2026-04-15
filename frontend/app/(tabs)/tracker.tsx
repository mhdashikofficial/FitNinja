import React, { useState, useRef } from 'react';
import { View, Text, StyleSheet, TouchableOpacity } from 'react-native';
import { Camera, CameraType } from 'expo-camera';
// Note: Deep TensorFlow.js and MediaPipe Pose integration requires extensive native 
// linking which requires prebuilding the app. 
// For this Expo-go runnable layout, we simulate the tracker overlay via bounding boxes 
// and camera integration, providing placeholder logic for where tfjs runs predictions.

export default function TrackerScreen() {
  const [permission, requestPermission] = Camera.useCameraPermissions();
  const [type, setType] = useState(CameraType.front);
  const [tracking, setTracking] = useState(false);

  if (!permission) {
    return <View />;
  }

  if (!permission.granted) {
    return (
      <View style={styles.center}>
        <Text style={{color:'#fff', marginBottom: 16}}>We need camera access for the Boxing AI Tracker</Text>
        <TouchableOpacity style={styles.btn} onPress={requestPermission}>
            <Text style={{color:'#fff'}}>Grant Permission</Text>
        </TouchableOpacity>
      </View>
    );
  }

  const toggleCameraType = () => {
    setType(current => (current === CameraType.back ? CameraType.front : CameraType.back));
  }

  return (
    <View style={styles.container}>
      <Camera style={styles.camera} type={type}>
        <View style={styles.overlay}>
          {tracking && (
             <View style={styles.skeletonOverlay}>
                 {/* This represents where pose points (Head, Shoulders, Hands) are drawn by MediaPipe */}
                 <View style={styles.targetHead} />
                 <View style={[styles.targetHand, {left: 40, top: 150}]} />
                 <View style={[styles.targetHand, {right: 40, top: 150}]} />
             </View>
          )}

          <View style={styles.hud}>
              <Text style={styles.hudText}>{tracking ? "AI SENSORS ACTIVE" : "AI TRACKER OFFLINE"}</Text>
              <Text style={styles.instructions}>
                  {tracking ? "Current Drill: Jab, Jab, Cross" : "Press Start to initialize pose detection"}
              </Text>
              <Text style={styles.speedText}>Speed: 0.0 m/s</Text>
          </View>

          <View style={styles.controls}>
            <TouchableOpacity style={styles.flipBtn} onPress={toggleCameraType}>
              <Text style={styles.flipText}>Flip</Text>
            </TouchableOpacity>
            <TouchableOpacity style={[styles.actionBtn, tracking && styles.actionBtnActive]} onPress={() => setTracking(!tracking)}>
              <Text style={styles.actionText}>{tracking ? "STOP TRACKING" : "START TRACKING"}</Text>
            </TouchableOpacity>
          </View>
        </View>
      </Camera>
    </View>
  );
}

const styles = StyleSheet.create({
  center: { flex: 1, backgroundColor: '#0A0A0A', justifyContent: 'center', alignItems: 'center', padding: 24 },
  btn: { backgroundColor: '#3b82f6', padding: 16, borderRadius: 8 },
  container: { flex: 1 },
  camera: { flex: 1 },
  overlay: { flex: 1, backgroundColor: 'transparent', justifyContent: 'space-between', padding: 24 },
  skeletonOverlay: { ...StyleSheet.absoluteFillObject, justifyContent: 'center', alignItems: 'center' },
  targetHead: { width: 80, height: 100, borderWidth: 2, borderColor: '#10b981', position: 'absolute', top: 80, borderRadius: 40 },
  targetHand: { width: 40, height: 40, borderWidth: 2, borderColor: '#ef4444', position: 'absolute', borderRadius: 20 },
  hud: { backgroundColor: 'rgba(0,0,0,0.5)', padding: 16, borderRadius: 12, marginTop: 40 },
  hudText: { color: '#10b981', fontWeight: 'bold', fontSize: 18, textAlign: 'center' },
  instructions: { color: '#fff', fontSize: 24, fontWeight: '800', textAlign: 'center', marginVertical: 8 },
  speedText: { color: '#ef4444', fontSize: 20, textAlign: 'center', fontStyle: 'italic', fontWeight: 'bold' },
  controls: { flexDirection: 'row', justifyContent: 'center', alignItems: 'center', marginBottom: 20 },
  flipBtn: { padding: 16, backgroundColor: 'rgba(255,255,255,0.2)', borderRadius: 12, marginRight: 16 },
  flipText: { color: '#fff', fontWeight: 'bold' },
  actionBtn: { padding: 16, backgroundColor: '#3b82f6', borderRadius: 12, flex: 1, alignItems: 'center' },
  actionBtnActive: { backgroundColor: '#ef4444' },
  actionText: { color: '#fff', fontWeight: 'bold', fontSize: 16 }
});
