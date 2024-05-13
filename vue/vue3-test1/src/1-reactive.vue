<script setup>
import { computed, ref } from 'vue';

const list = ref([1, 2, 3, 4, 5, 6, 7, 8])
const big = computed(() => {
  return list.value.filter(i => i % 2 == 0)
})

const add = () => {
  list.value.push(list.value.length + 1)
}

</script>

<template>
  <div>{{ list }}</div>
  <div>{{ big }}</div>
  <button @click="add">add</button>
</template>

<style scoped>
header {
  line-height: 1.5;
}

.logo {
  display: block;
  margin: 0 auto 2rem;
}

@media (min-width: 1024px) {
  header {
    display: flex;
    place-items: center;
    padding-right: calc(var(--section-gap) / 2);
  }

  .logo {
    margin: 0 2rem 0 0;
  }

  header .wrapper {
    display: flex;
    place-items: flex-start;
    flex-wrap: wrap;
  }
}
</style>
