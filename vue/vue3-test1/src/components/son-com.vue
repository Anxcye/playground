<script setup>
const props = defineProps({
  money: Number
})
const emit = defineEmits(['add'])
const addMoney = () => {
emit('add')
}
</script>

<template>
  <div id="son">

    <h2> son - {{ props.money }}</h2>
    <button @click="addMoney">add</button>
  </div>
</template>

<style scoped>
#son {
  border: 3px solid red;
  height: 100px;
}
</style>