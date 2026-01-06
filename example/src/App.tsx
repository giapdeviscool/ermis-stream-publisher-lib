import {
  ErmisStreamPublisherView,
  startStream,
  stopStream,
  flipCamera,
} from 'ermis-stream-publisher-lib';
import React from 'react';
import { View, StyleSheet, Button } from 'react-native';

export default function App() {
  const [cameraPosition, setCameraPosition] = React.useState<boolean>(true); // true is front, false is back
  const [isStreaming, setIsStreaming] = React.useState<boolean>(false);
  const flipCameraPosition = () => {
    setCameraPosition(!cameraPosition);
    flipCamera(cameraPosition);
  };

  const handleStartStream = () => {
    startStream();
    setIsStreaming(true);
  };

  const handleStopStream = () => {
    stopStream();
    setIsStreaming(false);
  };

  return (
    <View style={styles.container}>
      <ErmisStreamPublisherView
        rtmpUrl="rtmps://streaming.ermis.network:1939/Ermis-streaming"
        streamKey="019b914f-40a9-78b0-9b74-3d8485e18c20:13f9fe8f06678640"
        style={{
          width: '98%',
          height: '50%',
          backgroundColor: 'black',
          marginTop: 50,
        }}
        frameRate={60}
        videoBitrate={2500000}
        videoCodec={true}
        audioBitrate={160}
      />
      <View
        style={{
          flexDirection: 'row',
          justifyContent: 'space-around',
          width: '98%',
          borderBlockColor: 'black',
          borderWidth: 1,
          marginTop: 20,
          borderRadius: 5,
        }}
      >
        <Button
          title="flip camera"
          onPress={() => {
            flipCameraPosition();
          }}
          color={'green'}
        />
      </View>
      <View
        style={{
          flexDirection: 'row',
          justifyContent: 'space-around',
          width: '98%',
          borderBlockColor: 'black',
          borderWidth: 1,
          marginTop: 20,
          borderRadius: 5,
        }}
      >
        {isStreaming ? (
          <Button
            title="stop stream"
            onPress={handleStopStream}
            color={'green'}
          />
        ) : (
          <Button
            title="start stream"
            onPress={handleStartStream}
            color={'green'}
          />
        )}
      </View>
    </View>
  );
}

const styles = StyleSheet.create({
  container: {
    flex: 1,
    alignItems: 'center',
  },
});
