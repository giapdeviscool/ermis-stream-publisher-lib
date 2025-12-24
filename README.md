# ermis-stream-publisher-lib

an publisher for ermis stream

## Installation


```sh
npm install ermis-stream-publisher-lib react-native-nitro-modules

> `react-native-nitro-modules` is required as this library relies on [Nitro Modules](https://nitro.margelo.com/).
```


## Usage


```js
import {
  ErmisStreamPublisherView,
  startStream,
  stopStream,
  flipCamera,
  getDummyToken,
  getSDKToken,
} from 'ermis-stream-publisher-lib';

// ...

 <View style={styles.container}>
      <ErmisStreamPublisherView
        rtmpUrl="rtmps://streaming.ermis.network:1939/Ermis-streaming"
        streamKey="31428e22-a37b-44bd-aa8f-f4499fa07e8d:b85193223e19025a"
        style={{
          width: '98%',
          height: '50%',
          backgroundColor: 'black',
          marginTop: 50,
        }}
        frameRate={60}
        videoBitrate={2500}
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
            flipCamera();
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


```


## Contributing

- [Development workflow](CONTRIBUTING.md#development-workflow)
- [Sending a pull request](CONTRIBUTING.md#sending-a-pull-request)
- [Code of conduct](CODE_OF_CONDUCT.md)

## License

MIT

---

Made with [create-react-native-library](https://github.com/callstack/react-native-builder-bob)
