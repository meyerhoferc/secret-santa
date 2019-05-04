import axios from 'axios';

const loginPath = '/api/authenticate';

let AuthAPI = {
  login(username_email, password) {
    return new Promise(function(resolve, reject) {
      axios.post(loginPath, { username_email: username_email, password: password })
        .then((resp) => {
          resolve(resp.data);
          console.log(resp.data);
        })
        .catch((errResp) => reject(errResp.data));
    });
  }
};

export default AuthAPI;
