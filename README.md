##목적
- [카카오스토리 팀의 코드리뷰 도입 사례](http://tech.kakao.com/2016/02/04/kakaostory-codereview/) 글을 읽어보고 당장 리뷰 시스템 적용은 힘들지만 git hook을 통한 pre-commit시 convention 검사하는 것이 맘에 들었다. 그래서 이것 저것 찾아보니 Java용으로 마땅한 것을 못찾아서 만들어봄.

##사전 설치 필요
- [MVN](http://maven.apache.org/download.cgi)

##설치 실행
```
export JCHECK_HOME=/path_to_this_repo
cd /your_git_repo
jcheck.sh [-f your-checkstyle-rules.xml]
```

##TO DO
- git hook에 자동등록시키는 스크립트 아직 못했음.