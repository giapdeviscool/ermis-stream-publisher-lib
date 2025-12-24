import axios from 'axios';

const axiosClient = axios.create({
  baseURL: 'https://api-test.ermis.network/uss/v1/get_token', // baseURL
  timeout: 10000,
  headers: {
    'Content-Type': 'application/json',
  },
});

export async function getDummyToken(user_id: string) {
  const dummy_token = await axiosClient.get(
    `/dummy_external_token?user_id=${user_id}`
  );
  return dummy_token;
}

export async function getSDKToken(auth_token: string) {
  axiosClient.defaults.headers.common.Authorization = `Bearer ${auth_token}`;
  const stream_exchange_token = await axiosClient.get(
    `/stream_exchange_token?apikey=YxOyy4deq2ddvyU583GDzCgby8V7UErP`
  );
  return stream_exchange_token;
}
