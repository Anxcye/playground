<script setup>
import { useCounterStore } from "@/stores/counter";
import { onMounted } from "vue";
const counterStore = useCounterStore();
console.log(counterStore);

onMounted(() => {
    counterStore.getList();
    console.log(counterStore.list);
})
</script>

<template>
    <button @click="counterStore.increment">{{ counterStore.count }}</button>
    {{ counterStore.doubleCount }}
    <ul>
        <li v-for="item in counterStore.list" :key="item.id">{{ item.name }}</li>
    </ul>
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
