statocat - Stats for the octocat's home!
========

**statocat** is a statistics generator for GitHub profiles which is useful for employers to find potential employees based on the various code languages they write. **statocat** is open-sourced and will provide APIs for developers to develop their own unique versions of **statocat**.

## Features
**statocat** provides the following information given a GitHub user's username:

- **General Information**
  - Name
  - Username
  - Followers
  - Following
  - Public repos
  - Public gists
  - GitHub 'Birthday'

- **Repo Languages _(Pie Chart & Text)_**
  - Number of repositories
  - Percentage of all repositories

- **Code Languages _(Pie Chart & Text)_**
  - Number of characters
  - Number of lines
 
- **Stars**
  - Total stars
  - Average per repo

- **Forks**
  - Total forks
  - Average per repo

- **Pages**
  - Total pages
  - Percentage of repos with pages

- **Issues**
  - Total issues
  - Average number of issues per repository

## API Endpoints
**statocat** currently has two APIs open for developers to utilize. These APIs are listed below.

### `/u/[:user].json` - General information about a user
- Request:
```js
GET /u/[:user].json
```
- Response:
```js
Status: 200 OK

{  
   "updated_at":"2015-03-23T11:49:33.647Z",
   "name":"Zach Holman",
   "username":"holman",
   "followers":3904,
   "following":78,
   "join_date":"2008-03-10T16:32:37.000Z",
   "public_repos":47,
   "public_gists":23,
   "avatar":"https://avatars.githubusercontent.com/u/2723?v=3"
}
```
    

### `/u/[:user]/statistics` - Detailed user repo information
- Request:
```js
GET /u/[:user]/statistics
```
- Response:
```js
Status: 200 OK

{  
   "updated_at":"2015-03-23T11:49:34.777Z",
   "repo_lang":{  
      "JavaScript":3,
      "Ruby":12,
      "Shell":1,
      "CSS":1
   },
   "code_lang":{  
      "JavaScript":26868,
      "Ruby":216918,
      "Shell":33127,
      "CoffeeScript":3228,
      "AppleScript":2048,
      "CSS":10174
   },
   "total_stars":5326,
   "total_repos":30,
   "average_stars":177.53,
   "total_forks":2559,
   "average_forks":85.3,
   "total_characters":292363,
   "average_characters":9745.43,
   "total_issues":14,
   "average_issues":0.47,
   "total_pages":2,
   "percentage_pages":0.07
}
```
