<template>
  <div>
    <p>{{ msg }}</p>
  </div>
</template>

<script>
export default {
  name: "HelloWorld",
  props: {
    msg: {
      type: String,
      required: true, 
    },
  },
};
</script>

<style scoped>
p {
  font-size: 16px;
  color: #333;
}
</style>


<!-- <template>
  <div>
    <p>Este texto no depende del prop msg</p>
  </div>
</template>

<script>
export default {
  name: "HelloWorld",
  props: {
    msg: {
      type: String,
      required: true,
    },
  },
};
</script> -->
