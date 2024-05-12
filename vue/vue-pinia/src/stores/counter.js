import { defineStore } from "pinia";
import { computed, ref } from "vue";
import  axios  from "axios";

export const useCounterStore = defineStore('counter', () => {
    const count = ref(0)

    const increment = () => {
        count.value++
    }

    const doubleCount = computed(() => {
        return count.value * 2

    })

    // const API_URL = 'https://geek.itheima.net/v1_0/channels'
    const API_URL = 'http://geek.itheima.net/v1_0/channels'
    // 异步action
    const list = ref([])
    const getList = async () => {
        const res = await axios.get(API_URL);
        list.value = res.data.data.channels;
        console.log(list.value);
    }

    return {
        count,
        doubleCount,
        increment,
        list,
        getList
    }
})