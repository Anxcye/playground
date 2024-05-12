<template>
    <div>
        <!-- {{ message }} -->
        <element-view></element-view>

    </div>
</template>

<script>
import ElementView from './views/element/ElementView.vue'
export default {
    components: { ElementView },
    data() {
        return {
            message: "Hello World"
        }
    },
    methords: {

    }

}
</script>

<style scoped></style>
