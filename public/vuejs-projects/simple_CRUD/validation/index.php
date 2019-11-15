<!DOCTYPE html>
<html>
    <head>
        <title>Input Validation using Vue.js with PHP</title>
        <link
            rel="stylesheet"
            href="https://maxcdn.bootstrapcdn.com/bootstrap/3.3.7/css/bootstrap.min.css"/>
        <script src="https://cdnjs.cloudflare.com/ajax/libs/vue/2.5.10/vue.min.js"></script>
        <script src="https://cdnjs.cloudflare.com/ajax/libs/axios/0.17.1/axios.min.js"></script>
        <style type="text/css">
            .div-space {
                height: 20px;
            }
            .demo-label {
                margin-top: 7px;
            }
            .top-margin {
                margin-top: 10px;
            }
            .error {
                font-size: 13px;
            }
        </style>
    </head>
    <body>
        <div class="container">
            <h1 class="page-header text-center">Input Validation using Vue.js with PHP</h1>
            <div id="validate">
                <div class="row">
                    <div class="col-md-10 col-md-offset-1">
                        <div class="alert alert-success text-center" v-if="successMessage">
                            <button type="button" class="close" @click="clearMessage();">
                                <span aria-hidden="true">&times;</span></button>
                            <span class="glyphicon glyphicon-check"></span>
                            {{ successMessage }}
                        </div>
                        <div class="panel panel-primary">
                            <div class="panel-heading">
                                Input Form
                            </div>
                            <div class="panel-body">
                                <div class="top-margin"></div>
                                <div class="row">
                                    <div class="col-md-6">
                                        <div class="form-group">
                                            <div class="col-md-3">
                                                <label class="demo-label">Username:</label>
                                            </div>
                                            <div class="col-md-9">
                                                <input
                                                    type="text"
                                                    ref="username"
                                                    class="form-control"
                                                    v-model="forValidation.username">
                                                <div v-if="errorUsername" class="error">{{ errorUsername }}</div>
                                            </div>
                                        </div>
                                    </div>
                                    <div class="col-md-6">
                                        <div class="form-group">
                                            <div class="col-md-3">
                                                <label class="demo-label">Password:</label>
                                            </div>
                                            <div class="col-md-9">
                                                <input
                                                    type="password"
                                                    ref="password"
                                                    class="form-control"
                                                    v-model="forValidation.password">
                                                <div v-if="errorPassword" class="error">{{ errorPassword }}</div>
                                            </div>
                                        </div>
                                    </div>
                                </div>
                                <div class="div-space"></div>
                                <div class="row">
                                    <div class="col-md-6">
                                        <div class="form-group">
                                            <div class="col-md-3">
                                                <label class="demo-label">Firstname:</label>
                                            </div>
                                            <div class="col-md-9">
                                                <input
                                                    type="text"
                                                    ref="firstname"
                                                    class="form-control"
                                                    v-model="forValidation.firstname">
                                                <div v-if="errorFirstname" class="error">{{ errorFirstname }}</div>
                                            </div>
                                        </div>
                                    </div>
                                    <div class="col-md-6">
                                        <div class="form-group">
                                            <div class="col-md-3">
                                                <label class="demo-label">Lastname:</label>
                                            </div>
                                            <div class="col-md-9">
                                                <input
                                                    type="text"
                                                    ref="lastname"
                                                    class="form-control"
                                                    v-model="forValidation.lastname">
                                                <div v-if="errorLastname" class="error">{{ errorLastname }}</div>
                                            </div>
                                        </div>
                                    </div>
                                </div>
                                <div class="div-space"></div>
                                <div class="row">
                                    <div class="col-md-6">
                                        <div class="form-group">
                                            <div class="col-md-3">
                                                <label class="demo-label">Email:</label>
                                            </div>
                                            <div class="col-md-9">
                                                <input
                                                    type="text"
                                                    ref="email"
                                                    class="form-control"
                                                    v-model="forValidation.email">
                                                <div v-if="errorEmail" class="error">{{ errorEmail }}</div>
                                            </div>
                                        </div>
                                    </div>
                                    <div class="col-md-6">
                                        <div class="form-group">
                                            <div class="col-md-3">
                                                <label class="demo-label">Website:</label>
                                            </div>
                                            <div class="col-md-9">
                                                <input
                                                    type="text"
                                                    ref="website"
                                                    class="form-control"
                                                    v-model="forValidation.website">
                                                <div v-if="errorWebsite" class="error">{{ errorWebsite }}</div>
                                            </div>
                                        </div>
                                    </div>
                                </div>
                                <div class="div-space"></div>
                            </div>
                            <div class="panel-footer">
                                <button class="btn btn-primary" @click="validateInput();">
                                    <span class="glyphicon glyphicon-check"></span>
                                    Validate</button>
                            </div>
                        </div>
                    </div>
                </div>
            </div>
        </div>
        <script src="app.js"></script>
    </body>
</html>