
#[cfg(test)]
mod tests;

use std::vec::Vec;
use git2::{Error,Repository,Oid,Sort,DiffOptions,Time,Signature};

// TODO optimize operations on collections

pub struct Delta {
    hash: Oid,
    summary: String,
    file_name: String,
    time: Time,
    author: String,
    additions: usize,
    deletions: usize,
}

pub fn list_commits<'a>(repo: &'a Repository) -> Result<Vec<Oid>, Error> {
    let mut revwalk = repo.revwalk()?;
    revwalk.set_sorting(Sort::TOPOLOGICAL | Sort::TIME);
    revwalk.push_head()?;

    // TODO use iterator for more optimal code
    let mut result = vec![];
    for rev in revwalk {
        let oid = rev?;
        // skip merge commits in analysis:
        if repo.find_commit(oid)?.parent_ids().len() > 1 {
            continue;
        }
        result.push(oid);
    }
    result.reverse();
    Ok(result)
}

pub fn extract_diff_info<'a>(repo: &'a Repository, oid: Oid,
                             file: String) -> Result<Delta, Error> {
    let mut diff_opts = DiffOptions::new();
    let diff_opts = Some(diff_opts.pathspec(file.clone()));
    let commit = repo.find_commit(oid)?;
    let tree = commit.tree()?;
    let diff = match commit.parents().count() {
        0 => {  // Starting commit has no parent
            repo.diff_tree_to_tree(None, Some(&tree), diff_opts)?
        },
        _ => {
            let parent_commit = commit.parent(0)?;
            let parent_tree = parent_commit.tree()?;
            repo.diff_tree_to_tree(Some(&parent_tree), Some(&tree), diff_opts)?
        },
    };

    let stats = diff.stats()?;
    let hash = commit.id();
    let msg = commit.message().unwrap().to_string();
    let time = commit.time();
    let author = commit.author().name().unwrap().to_string();
    Ok(Delta {
        hash: hash,
        summary: msg,
        file_name: file,
        time: time,
        author: author,
        additions: stats.insertions(),
        deletions: stats.deletions(),
    })
}

