import ballerina/http;

type Album readonly & record {|
    string title;
    string artist; 
|};

table<Album> key(title) albums = table [
    {title: "1989", artist: "Taylor Swift"},
    {title: "Reputation", artist: "Taylor Swift"},
    {title: "Lover", artist: "Taylor Swift"}
];


service / on new http:Listener(9090) {
    resource function get albums/[string title]() returns Album|http:NotFound {
        Album? album = albums[title];
        if album is (){
            return http:NOT_FOUND;
        }  
        return album;
    }

    resource function post albums(Album album) returns Album {
        albums.add(album);
        return album;
    }

    resource function get albums(string artist) returns Album[] {
        return from Album album in albums
            where album.artist == artist
            select album;
    }
    
}