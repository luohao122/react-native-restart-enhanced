import { StyleSheet, Text, Button, SafeAreaView } from 'react-native';
import { restart } from 'react-native-restart-enhanced';

export default function App() {
  const handleRestart = async () => {
    // Adding a delay to ensure the native module is ready
    await restart();
  };

  return (
    <SafeAreaView style={styles.container}>
      <Text>Hello World</Text>
      <Button title="Press Me" onPress={handleRestart} />
    </SafeAreaView>
  );
}

const styles = StyleSheet.create({
  container: {
    flex: 1,
    alignItems: 'center',
    justifyContent: 'center',
  },
  box: {
    width: 60,
    height: 60,
    marginVertical: 20,
  },
});
