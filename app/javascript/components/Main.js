import React from "react";
import PropTypes from "prop-types";
import HelloWorld from './HelloWorld.js';

class Main extends React.Component {
  render () {
    return (
      <React.Fragment>
        Greeting: {this.props.greeting}
        <br />
        <HelloWorld greeting="This is Hello World's greeting" />
      </React.Fragment>
    );
  }
}

Main.propTypes = {
  greeting: PropTypes.string
};
export default Main
