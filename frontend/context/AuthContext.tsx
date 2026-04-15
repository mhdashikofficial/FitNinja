import React, { createContext, useContext, useState, useEffect } from 'react';
import AsyncStorage from '@react-native-async-storage/async-storage';

type AuthContextType = {
  token: string | null;
  onboardingCompleted: boolean;
  login: (token: string, onboardingStatus: boolean) => Promise<void>;
  logout: () => Promise<void>;
  completeOnboarding: () => Promise<void>;
  isLoading: boolean;
};

const AuthContext = createContext<AuthContextType | null>(null);

export const useAuth = () => {
    const ctx = useContext(AuthContext);
    if (!ctx) throw new Error("useAuth must be used within AuthProvider");
    return ctx;
};

export const AuthProvider = ({ children }: { children: React.ReactNode }) => {
  const [token, setToken] = useState<string | null>(null);
  const [onboardingCompleted, setOnboardingCompleted] = useState<boolean>(false);
  const [isLoading, setIsLoading] = useState(true);

  useEffect(() => {
    const loadStorage = async () => {
      try {
        const storedToken = await AsyncStorage.getItem('token');
        const onboardingStr = await AsyncStorage.getItem('onboardingCompleted');
        if (storedToken) setToken(storedToken);
        if (onboardingStr === 'true') setOnboardingCompleted(true);
      } catch (e) {}
      setIsLoading(false);
    };
    loadStorage();
  }, []);

  const login = async (tkn: string, onboardingStatus: boolean) => {
    await AsyncStorage.setItem('token', tkn);
    await AsyncStorage.setItem('onboardingCompleted', onboardingStatus.toString());
    setToken(tkn);
    setOnboardingCompleted(onboardingStatus);
  };

  const logout = async () => {
    await AsyncStorage.removeItem('token');
    await AsyncStorage.removeItem('onboardingCompleted');
    setToken(null);
    setOnboardingCompleted(false);
  };

  const completeOnboarding = async () => {
    await AsyncStorage.setItem('onboardingCompleted', 'true');
    setOnboardingCompleted(true);
  };

  return (
    <AuthContext.Provider value={{ token, onboardingCompleted, login, logout, completeOnboarding, isLoading }}>
      {children}
    </AuthContext.Provider>
  );
};
