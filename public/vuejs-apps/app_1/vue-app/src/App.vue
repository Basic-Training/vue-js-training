<template>
  <div id="app">
    <img alt="Vue logo" src="./assets/logo.png">
    <Test/>
    <test2/>
  </div>
</template>
<script>
import Test from './components/Test.vue'
import Test2 from './components/Test2'
export default {
  name: 'app',
  components: {
    Test, Test2
  }
}
</script>