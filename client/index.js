/**
 * ************************************
 *
 * @module  index
 * @author  boilerplate
 * @date    boilerplate
 * @description entry point for react app
 *
 * ************************************
 */

import React from 'react';
import ReactDOM from 'react-dom';
import { Provider } from 'react-redux';
import { AppContainer } from 'react-hot-loader';
import { BrowserRouter, Route } from 'react-router-dom';
import App from './App';
import store from './store';
import LocationListener from './components/navigation/LocationListener';

// import for global styles
import './stylesheets/global/style.scss';

const render = (Component) => {
  ReactDOM.render(
    <Provider store={store}>
      <BrowserRouter>
        <LocationListener>
          <AppContainer>
            <Component />
          </AppContainer>
        </LocationListener>
      </BrowserRouter>
    </Provider>,
    document.getElementById('app')
  );
};

render(App);

if (module.hot) {
  module.hot.accept('./App.jsx', function () { return render(App) });
}
