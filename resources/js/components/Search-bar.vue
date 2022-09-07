<template>
    <nav class="navbar navbar-expand-lg navbar-dark bg-dark">
        <div class="container-fluid">
            <a class="navbar-brand" href="#"></a>
            <button class="navbar-toggler" type="button" data-bs-toggle="collapse" data-bs-target="#navbarNav" aria-controls="navbarNav" aria-expanded="false" aria-label="Toggle navigation">
                <span class="navbar-toggler-icon"></span>
            </button>
            <div class="collapse navbar-collapse" id="navbarNav">
                <ul class="navbar-nav ms-md-auto gap-2">
                    <li class="nav-item rounded">
                        <a class="nav-link" :class=" showAPI ? 'active' : ''" aria-current="page" @click="showUnsplash"><i class="bi bi-house-fill me-2"></i>Home</a>
                    </li>
                    <li class="nav-item rounded">
                        <a class="nav-link" :class=" showAPI ? '' : 'active'"  @click="showLikes"><i class="bi bi-people-fill me-2"></i>Liked</a>
                    </li>
                </ul>
            </div>
        </div>
    </nav>
    <div class="container" v-if="showAPI === true">
        <h1 class="text-center mt-30"> {{ title }} </h1>
        <div class="row height d-flex justify-content-center align-items-center mt-30" >
            <div class="row d-flex justify-content-center mt-30">
                <div class="form-group col-6">
                    <input type="text" ref="data" class="form-control" placeholder="Photos title">
                </div>
                <div class="form-check col-3">
                    <button @click="queryData" class="w-100 btn btn-outline-primary">Search</button>
                </div>
            </div>
        </div>
        <h3 v-if=" info != null">
            {{ info }}
        </h3>
        <div class="row d-flex justify-content-center align-items-center mt-30">
            <div class="row">
                <div v-for="(image, id) in images" v-if="hasImages" :key="image._id" class="col-lg-6 col-md-4 col-xs-6 mt-30 thumb">
                    <div class="row">
                        <a class="thumbnail" id="preview" href="#" data-image-id="" data-toggle="modal" data-title=""
                        :data-image="`${image.url}`"
                        data-target="#image-gallery">
                            <img class="img-thumbnail img-responsive img-fixed"
                                :src="`${image.url}`"
                                :alt="`${image.alt}`">
                        </a>
                    </div>
                    <div class="d-flex row mt-10 justify-content-center">
                        <div class="col-md-12 overflow-hidden ">
                            <h4 v-show="!image.edit" class="text-muted"> {{ image.description }} </h4>
                            <div class="row" v-show="image.edit">
                                <div class="col-md-10">      
                                    <input type="text" ref="desc" :id="id" class="form-control" placeholder="Image Description">
                                </div>
                                <div class="col-md-2">
                                    <button v-on:click="editDescription(image)" class="btn btn-primary"> Submit </button>
                                </div>
                            </div>
                        </div>
                        <div class="d-flex row justify-content-center">
                            <div class="col-md-2">
                                <button type="button w-100" @click="like(`${image.url}`, `${image.alt}`, `${image.description}`)" class="btn" :class="likedImgLink.includes(`${image.url}`) ? 'btn-success' : 'btn-outline-dark' ">Like</button>
                            </div>
                            <div class="col-md-2">
                                <button type="button" @click="editToggle(image)" class="btn btn-outline-dark">Edit</button>
                            </div>
                        </div>
                    </div>
                </div>
            </div>
        </div>
    </div>
    <div class="container" v-else>
        <h1 class="text-center mt-30"> Liked Photos </h1>
        <div class="row d-flex justify-content-center align-items-center mt-30">
            <div class="row">
                <div v-for="(image, id) in likedImg" v-if="hasImages" :key="image._id" class="col-lg-6 col-md-4 col-xs-6 mt-30 thumb">
                    <div class="row">
                        <a class="thumbnail" id="preview" href="#" data-image-id="" data-toggle="modal" data-title=""
                        :data-image="`${image.url}`"
                        data-target="#image-gallery">
                            <img class="img-thumbnail img-responsive img-fixed"
                                :src="`${image.url}`"
                                :alt="`${image.alt}`">
                        </a>
                    </div>
                    <div class="d-flex row mt-10 justify-content-center">
                        <div class="col-md-12 overflow-hidden ">
                            <h4 v-show="!image.edit" class="text-muted"> {{ image.description }} </h4>
                            <div class="row" v-show="image.edit">
                                <div class="col-md-10">      
                                    <input type="text" ref="desc" :id="id" class="form-control" placeholder="Image Description">
                                </div>
                                <div class="col-md-2">
                                    <button v-on:click="editDescription(image)" class="btn btn-primary"> Submit </button>
                                </div>
                            </div>
                        </div>
                        <div class="d-flex row justify-content-center">
                            <div class="col-md-2">
                                <button type="button w-100" @click="like(`${image.url}`, `${image.alt}`, `${image.description}`)" class="btn" :class="likedImgLink.includes(`${image.url}`) ? 'btn-success' : 'btn-outline-dark' ">Like</button>
                            </div>
                            <div class="col-md-2">
                                <button type="button" @click="editToggle(image)" class="btn btn-outline-dark">Edit</button>
                            </div>
                        </div>
                    </div>
                </div>
            </div>
        </div>
    </div>
</template>
<script>
    import axios from 'axios'
    let imageElement = document.getElementById("#photo");
    
    const API = "https://api.unsplash.com/search/photos?query=";
    export default {
        name: "search-bar",
        data() {
            return {
                title: "Unsplash API Image Generator",
                showAPI: true,
                query: "",
                unsplash: "",
                client_id: "DdF1kstrJ32d_cWyF5qbnQOE0ZlWriX00J34DGJawX8",
                info: null,
                img: null,
                hasImages: false,
                images: [],
                likedImg: [],
                likedImgLink: [],
                liked: false,
                edit: false,
                newName: ""
            }
        },
        methods: {
            async queryData(){
                this.query = this.$refs.data.value;
                this.unsplash = API + this.query +"&client_id=" + this.client_id;
                this.images = [];
                this.hasImages = false;
                try {
                    const response = await fetch(this.unsplash, {
                    method: 'GET',
                    headers: {
                        accept: 'application/json',
                        },
                    });

                    if (!response.ok) {
                        throw new Error(`Error! status: ${response.status}`);
                    }

                    const result = await response.json();
                    var api = result.results;

                    api.forEach(item => {
                        this.images.push({url: item.urls.regular, alt: item.alt_description,description: item.description, edit: false});
                        this.hasImages = true;
                    })
                } catch (err) {
                        console.log(err);
                }
            },
            like(link, alt, description) {
                if (this.likedImgLink.includes(link))
                {
                    this.likedImgLink.splice(link, 1);
                }
                else {
                    this.likedImg.push({url: link, alt: alt,description: description});
                    this.likedImgLink.push(link);
                }
            },
            showLikes() {
                this.showAPI = false
            },
            showUnsplash(){
                this.showAPI = true
            },
            editToggle(image) {
                this._originalImage = Object.assign({}, image);
                image.edit = !image.edit;
            },
            editDescription(image){
                this._originalImage = Object.assign({}, image);
                image.description = this.$refs['desc'][0].value;
                image.edit = false;
            }
        }
    };
</script>
<style scoped>
    body {
        position: absolute; 
        top: 0; left: 0; right: 0; bottom: 0;  background-size: cover;
    }
    .mt-30
    {
        margin-top: 30px;
    }
    .mt-10
    {
        margin-top: 10px;
    }
    .mt-20 
    {
        margin-top: 20px;
    }
    .img-responsive {
        max-width: 100%;
        height: auto;
    }
    .img-fixed {
        height: 720px;
        width: 100%;
        object-fit: cover
    }
    #image-gallery .modal-footer{
        display: block;
    }
    .thumb{
        margin-top: 15px;
        margin-bottom: 15px;
      }
      .heart-icon {
        width: auto;
        height: 30px;
    }
      
      .heart-icon path {
        fill: none;
        stroke-width: 2;
        stroke: #1b1b1b;
    }
      
</style>