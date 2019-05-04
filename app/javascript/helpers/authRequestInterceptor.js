import store from '../store.js';

export default function() {
  console.log(store);
  axios.interceptors.request.use(function (config) {
    config.headers.Authorization = 'Bearer ' + store.getState().authToken;
    return config;
  });
}
