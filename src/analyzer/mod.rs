
#[cfg(test)]
mod tests;

use std::vec::Vec;
use git2::{Error,Repository,Oid,Sort};

// TODO optimize operations on collections

pub fn analyze_repo<'a>(repo_dir: &'a str) -> Vec<Commit<'a>> {
    vec![]
}

pub fn list_commits<'a>(repo_dir: &'a str) -> Result<Vec<Oid>, Error> {
    let repo = Repository::open(repo_dir)?;
    let mut revwalk = repo.revwalk()?;
    revwalk.set_sorting(Sort::TOPOLOGICAL | Sort::TIME);
    revwalk.push_head()?;

    let mut result = vec![];
    for rev in revwalk {
        let id = rev?;
        println!("{}", id);
        result.push(id);
    }
    Ok(result)
}

pub struct Commit<'a> {
    hash: &'a str,
    description: &'a str,
    diffs: Vec<Diff<'a>>,
}

pub struct Diff<'a> {
    filename: &'a str,
    additions: u64,
    deletions: u64,
}
