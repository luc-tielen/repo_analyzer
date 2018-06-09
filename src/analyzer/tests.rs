
use std::vec::Vec;
use analyzer::{list_files_in_commit,list_commits,extract_diff_info};
use git2::{Oid,Repository};

#[test]
fn list_files_in_repo_for_commit() {
    let repo = Repository::open("./fixtures").unwrap();
    let commits: Vec<Oid> = list_commits(&repo)
        .unwrap()
        .collect();
    let files3 = list_files_in_commit(&repo, commits[0]).unwrap();
    let files2 = list_files_in_commit(&repo, commits[1]).unwrap();
    let files1 = list_files_in_commit(&repo, commits[2]).unwrap();
    assert_eq!(files3, ["file1", "file2"]);
    assert_eq!(files2, ["file1"]);
    assert_eq!(files1, ["file1"]);
}

#[test]
fn listing_commits() {
    let repo = Repository::open("./fixtures").unwrap();
    let commits = list_commits(&repo).unwrap();
    let commit_strings: Vec<String> =
        commits.map(|c| format!("{}", c)).collect();
    let expected: Vec<&str> = vec![
        "19a6ca15ecb29c4debd5b32181c3f7af22b05923",
        "20d2b7e9858b02a658eee11dfbab2fc8a3f1c900",
        "5a88fa35c3e589537ff04ffa4bd8203409fe6e36",
    ];
    assert_eq!(commit_strings, expected);
}

#[test]
fn extracting_diff_info() {
    let repo = Repository::open("./fixtures").unwrap();
    let mut commits = list_commits(&repo).unwrap();
    let commit3 = commits.next().unwrap();
    let commit2 = commits.next().unwrap();
    let commit1 = commits.next().unwrap();

    let diff1 = extract_diff_info(&repo, commit1, "file1".to_string()).unwrap();
    let diff2_1 = extract_diff_info(&repo, commit2, "file1".to_string()).unwrap();
    let diff2_2 = extract_diff_info(&repo, commit2, "file2".to_string()).unwrap();
    let diff3_1 = extract_diff_info(&repo, commit3, "file1".to_string()).unwrap();
    let diff3_2 = extract_diff_info(&repo, commit3, "file2".to_string()).unwrap();
    assert_eq!(diff1.file_name, "file1");
    assert_eq!(diff1.additions, 3);
    assert_eq!(diff1.deletions, 0);
    assert_eq!(diff2_1.additions, 1);
    assert_eq!(diff2_1.deletions, 1);
    assert_eq!(diff2_2.additions, 0);
    assert_eq!(diff2_2.deletions, 0);
    assert_eq!(diff3_1.additions, 1);
    assert_eq!(diff3_1.deletions, 1);
    assert_eq!(diff3_2.additions, 3);
    assert_eq!(diff3_2.deletions, 0);
}
