'use strict';

import '../assets/style';
import SettingAction from './Action/SettingAction.js';

window.onload = function() {
  const setting = new SettingAction();
  setting.addListenChangePeople();
}

// vim: ft=javascript.jsx

