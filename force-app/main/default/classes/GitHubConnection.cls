global class GitHubConnection extends DataSource.Connection {
    
    override global List<DataSource.Table> sync() {
        List<DataSource.Column> gitHubRepoColumns = new List<DataSource.Column>();
        gitHubRepoColumns.add(DataSource.Column.text('ExternalId', 255));
        gitHubRepoColumns.add(DataSource.Column.url('DisplayUrl'));
        gitHubRepoColumns.add(DataSource.Column.text('Name', 128));
        gitHubRepoColumns.add(DataSource.Column.text('Description', 1024));
        gitHubRepoColumns.add(DataSource.Column.number('Stars', 16, 0));
        
        List<DataSource.Table> tables = new List<DataSource.Table>();
        tables.add(DataSource.Table.get('GitHub Repos', 'Name', gitHubRepoColumns));
        return tables;
    }
    
    override global DataSource.TableResult query(DataSource.QueryContext queryContext) {
        List<Map<String, Object>> repos = DataSource.QueryUtils.process(queryContext, getOrgRepos('developerforce'));
        DataSource.TableResult tableResult = DataSource.TableResult.get(queryContext, repos);
        return tableResult;
    }
    
    override global List<DataSource.TableResult> search(DataSource.SearchContext searchContext) {
        return DataSource.SearchUtils.searchByName(searchContext, this);
    }
    
    public List<Map<String, Object>> getOrgRepos(String org) {
        Http httpProtocol = new Http();
        HttpRequest request = new HttpRequest();
        String url = 'https://api.github.com/orgs/' + org + '/repos?per_page=1000';
        request.setEndPoint(url);
        request.setMethod('GET');
        HttpResponse response = httpProtocol.send(request);
        
        List<Map<String, Object>> repos = new List<Map<String, Object>>();
        
        for (Object item : (List<Object>)JSON.deserializeUntyped(response.getBody())) {
            Map<String, Object> repo = (Map<String, Object>)item;
            repo.put('ExternalId', repo.get('id'));
            repo.put('DisplayUrl', repo.get('html_url'));
            repo.put('Name', repo.get('name'));
            repo.put('Description', repo.get('description'));
            repo.put('Stars', repo.get('stargazers_count'));
            repos.add(repo);
        }
        
        return repos;
    }
    
}