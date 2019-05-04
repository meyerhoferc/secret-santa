import { createStore } from 'redux';
import authReducer from './reducers/authReducer.js';

export default createStore(authReducer);
