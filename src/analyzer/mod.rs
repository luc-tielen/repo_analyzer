
#[cfg(test)]
mod tests;

use git2::{Error,Repository,Oid,Sort,StatusOptions,DiffOptions};

#[derive(Serialize)]
pub struct Delta {
    hash: String,
    summary: String,
    file_name: String,
    time: i64,  // seconds since epoch
    author: String,
    additions: usize,
    deletions: usize,
}

pub fn list_files_in_repo<'a>(repo: &'a Repository)
    -> Result<Vec<String>, Error> {
    let mut status_opts = StatusOptions::new();
    status_opts.include_unmodified(true).no_refresh(true);
    Ok(repo.statuses(Some(&mut status_opts))?
           .iter()
           .filter_map(|file| file.path().map(|path| path.to_string()))
           .collect())
}

pub fn list_commits<'a>(repo: &'a Repository)
    -> Result<impl Iterator<Item=Oid> + 'a, Error> {
    let mut revwalk = repo.revwalk()?;
    revwalk.set_sorting(Sort::TOPOLOGICAL | Sort::TIME);
    revwalk.push_head()?;

    // Slightly clunky way of filtering out merge commits;
    // this is because there is no IntoIterator for revwalk => filter borrows values..
    Ok(revwalk.filter_map(move |rev| {
        rev.and_then(move |oid| {
            repo.find_commit(oid)
                .and_then(|commit| {
                    if commit.parent_ids().len() <= 1 {
                        Ok(oid)
                    } else {
                        Err(Error::from_str("skipping merge commits"))
                    }
                })
        }).ok()
    }))
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
        hash: format!("{}", hash),
        summary: msg,
        file_name: file,
        time: time.seconds(),
        author: author,
        additions: stats.insertions(),
        deletions: stats.deletions(),
    })
}

