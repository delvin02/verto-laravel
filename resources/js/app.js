import './bootstrap';

import '../sass/app.scss'
import * as bootstrap from 'bootstrap'

import { createApp } from 'vue';

import app from './components/Welcome.vue';
import search from './components/Search-bar.vue';

createApp(search).mount("#app");
