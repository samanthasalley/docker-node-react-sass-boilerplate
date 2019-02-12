/**
 * ************************************
 *
 * @module  reactGA.js
 * @author  boilerplate
 * @date    boilerplate
 * @description Util for creating a React Google-Analytics singleton
 * 
 * ************************************
 */

import ReactGA from 'react-ga';

let instance = null;

const getReactGAInstance = () => {
  if (instance) {
    return instance;
  }
  const uaId = window.location.hostname === 'codesmith.io'
    || window.location.hostname === 'www.codesmith.io'
    ? 'UA-56972504-1' // prod tracking id
    : 'UA-129396556-1'; // dev tracking id
  instance = ReactGA;
  instance.initialize(uaId, { debug: true });
  return instance
};
export const ReactGAInstance = getReactGAInstance();
