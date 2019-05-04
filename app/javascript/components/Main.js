import React from "react";
import PropTypes from "prop-types";
import HelloWorld from './HelloWorld.js';
import LoginForm from './LoginForm.js';

import { Provider } from 'react-redux';
import store from '../store.js';
import '../helpers/authRequestInterceptor.js';

class Main extends React.Component {
  render () {
    return (
      <Provider store={store}>
        Greeting: {this.props.greeting}
        <br />
        <HelloWorld greeting="This is Hello World's greeting" />
        <LoginForm />
      </Provider>
    );
  }
}

Main.propTypes = {
  greeting: PropTypes.string
};
export default Main
