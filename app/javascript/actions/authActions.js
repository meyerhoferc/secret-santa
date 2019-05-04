export function setAuthProgress(progress) {
  return {
    type: 'SET_AUTH_PROGRESS',
    payload: progress,
  };
}

export function addAuthError(error) {
  return {
    type: 'ADD_AUTH_ERROR',
    payload: error,
  };
}

export function removeAuthErrors() {
  return {
    type: 'REMOVE_AUTH_ERRORS',
  };
}

export function setAuthToken(value) {
  return {
    type: 'SET_AUTH_TOKEN',
    payload: value,
  };
}

export function setUsername(username) {
  return {
    type: 'SET_USERNAME',
    payload: username,
  };
}

export function setUserId(id) {
  return {
    type: 'SET_USER_ID',
    payload: id,
  };
}
