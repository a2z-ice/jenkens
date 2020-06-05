pipeline {
    agent any

    parameters {
        choice(choices: ['test-namespace','prod-namespace'], description: 'Which name space?', name: 'K8S_NAMESPACE')
        }

    environment {
        REGISTRY="name of custom registry for tag creation"
        DEPLOYMENT_ENV="k8s"
        IMAGE_CREATED_BY="jenkins"
        PROJECT_NAME="fastpass-service"
        
        GIT_TAG=sh(returnStdout: true, script: '''
            COMMIT_ID=$(git log -1|head -1|awk -F ' ' '{print $NF}')
            echo $(git show-ref --tag | grep $COMMIT_ID | awk -F '/' '{print $NF}')
        ''').trim()
     
        //Host specific configuration
        HOST_VOLUME_LOCATION="/Volumes/Other/project/batworld/jenkins-cicd/volume-data"
        M2_REPO="/Users/assad/.m2/"

        DEPLOYMENT_ENV_VERSION=sh(returnStdout: true, script: '''    
                if [ $K8S_NAMESPACE == "prod-namespace" ]
                then
                    echo ""
                else
                    echo "-test"
                fi
            '''
        ).trim()        


        PROJECT_LOCATION="$HOST_VOLUME_LOCATION/workspace/$JOB_NAME"
        IMAGE_VERSION="$BUILD_NUMBER-$IMAGE_CREATED_BY-$GIT_TAG$DEPLOYMENT_ENV_VERSION"
        DOCKER_TAG="$REGISTRY/$PROJECT_NAME:$IMAGE_VERSION"
        DEPLOYMENT_DIRECTORY="./deploy/$DEPLOYMENT_ENV"
        
        //k8s cluster specific configuration
        K8S_SERVICE_NAME="$PROJECT_NAME"
        K8S_CHANGE_CAUSE="$IMAGE_VERSION"

        K8S_NODE_PORT=sh(returnStdout: true, script: '''    
                if [ $K8S_NAMESPACE == "industry-4-0" ]
                then
                    echo "30061"
                else
                    echo "31061"
                fi
            '''
        ).trim()

    }

    stages {        
        stage('Test') {
            steps {
                sh '''
                echo "Node port value -------->$K8S_NODE_PORT"
                '''
            }
        }
        stage('Build') {
            steps {
                sh '''
                echo "release.version=Release Version is $IMAGE_VERSION" > src/main/resources/release-note.properties
                echo "Maven build for Tag.....$GIT_TAG"
                docker run --rm \
                -v $PROJECT_LOCATION:/app -v $M2_REPO:/root/.m2/ -w /app \
                maven:3-alpine \
                mvn clean package -B \
                -Dmaven.test.skip=true \
                #-Dactive.profile=docker \
                '''
                }
             
        }        
      stage('Build Docker Image') {
            steps {
                sh '''
                echo "Building docker $DOCKER_TAG image"
                docker build -f $DEPLOYMENT_DIRECTORY/k8s.Dockerfile -t $DOCKER_TAG .
                docker images|grep $PROJECT_NAME
                '''
            }
        }
    
      stage('Push to Docker Registry') {
            steps {
                echo "Pushting to docker registry $DOCKER_TAG image"
                sh 'docker push $DOCKER_TAG'
            }
        } 
           
      stage('Deleted image After upload to Registry') {
            steps {
                echo "Cleaning local docker registry $DOCKER_TAG image"
                sh 'docker rmi $DOCKER_TAG'
            }
        }
      
     stage('K8S Deployment') {
            steps {
                sh '''
                envsubst < $DEPLOYMENT_DIRECTORY/k8s-deployment.yaml | xargs -I{} echo {}
                envsubst < $DEPLOYMENT_DIRECTORY/k8s-service.yaml | xargs -I{} echo {}
                '''
            }
        }

     stage('Clean Git Tags') {
            steps {
                sh '''
                echo "removing all tags"
                git tag -d $(git tag -l)
                echo "removing all tags done"
                '''
            }
        }        
                             
    }
}
