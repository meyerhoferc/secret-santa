const initialState = {
  authRequestInProgress: false,
  authErrors: [],
  authToken: null,
  username: null,
  userID: null,
};

const authReducer = (state = initialState, action) => {
  switch (action.type) {
    case 'SET_AUTH_PROGRESS':
      return {
        ...state,
        authRequestInProgress: action.payload,
      };
    case 'ADD_AUTH_ERROR':
      return {
        ...state,
        authErrors: [...state.authErrors, action.payload],
      };
    case 'REMOVE_AUTH_ERRORS':
      return {
        ...state,
        authErrors: [],
      };
    case 'SET_AUTH_TOKEN':
      return {
        ...state,
        authToken: action.payload,
      };
    case 'SET_USERNAME':
      return {
        ...state,
        username: action.payload,
      };
    case 'SET_USER_ID':
      return {
        ...state,
        userID: action.payload,
      };
    default:
      return state;
  }
};

export default authReducer;
