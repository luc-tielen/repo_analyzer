
use std::vec::Vec;
use analyzer::list_commits;
use git2::Error;


#[test]
fn listing_commits() {
    match list_commits("./fixtures") {
        Ok(commits) => {
            let commit_strings: Vec<String> =
                commits.iter().map(|c| format!("{}", c)).collect();
            let expected: Vec<&str> = vec![
                "19a6ca15ecb29c4debd5b32181c3f7af22b05923",
                "20d2b7e9858b02a658eee11dfbab2fc8a3f1c900",
                "5a88fa35c3e589537ff04ffa4bd8203409fe6e36"
            ];
            assert_eq!(commit_strings, expected);
        }
        Err(e) => assert!(false)
    };
}
