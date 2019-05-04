import React from 'react';
import { connect } from 'react-redux';
import AuthAPI from '../helpers/authAPI';
import { setAuthProgress, addAuthError, removeAuthErrors,
         setAuthToken, setUsername, setUserId } from '../actions/authActions.js';

class LoginForm extends React.Component {

  handleLogin(e) {
    e.preventDefault();
    let username_email = this.refs.username_email.value.trim();
    let password = this.refs.password.value.trim();
    this.props.setAuthProgress(true);
    AuthAPI.login(username_email, password);
  }

  renderAuthErrors() {
    let errors = this.props.authErrors;
    if (errors.length === 0) { return null; }
    return (
      <ul className="AuthErrors">{ errors.map((err) => ( <li>{err}</li> )) }</ul>
    );
  }

  render() {
    // let buttonText = this.props.authRequestInProgress ? 'Submitting...' : 'Login';
    let buttonText = 'Login';
    //disabled={this.props.authRequestInProgress}
    return (
      <form onSubmit={this.handleLogin.bind(this)}>
        { this.renderAuthErrors() }
        <input type="text" name="username_email" ref="username_email" />
        <input type="password" name="password" ref="password" />
        <button >{buttonText}</button>
      </form>
    );
  }
}

const mapStateToProps = state => ({
  authRequestInProgress: state.authRequestInProgress,
  authErrors: state.authErrors,
  authToken: state.authToken,
  username: state.username,
  userID: state.userId,
});

const mapDispatchToProps = dispatch => ({
  setAuthProgress: (progress) => {
    dispatch(setAuthProgress(progress));
  },
  addAuthError: (error) => {
    dispatch(addAuthError(error));
  },
  removeAuthErrors: () => {
    dispatch(removeAuthErrors());
  },
  setAuthToken: (value) => {
    dispatch(setAuthToken(value));
  },
  setUsername: (username) => {
    dispatch(setUsername(username));
  },
  setUserId: (id) => {
    dispatch(setUserId(id));
  },
});

export default connect(mapStateToProps, mapDispatchToProps)(LoginForm);
